//You will need to customize it to ensure it meets your needs and
//the data provided by the third party.

global class GoogleAuthHandler implements Auth.RegistrationHandler{
    
    
    global boolean canCreateUser(Auth.UserData data) {
        try{
            User user = [SELECT Id FROM User WHERE IsActive = TRUE AND Email = :data.email AND Profile.UserType = 'Customer Portal User'];
        }
        //will throw query exception if none found or more than one found in both case return false
        catch(Exception ex)    {
            return true;
        }
        return false;
    }

    global User createUser(Id portalId, Auth.UserData data){
        
        if(!canCreateUser(data)) {
            User user = [SELECT Id FROM User WHERE IsActive = TRUE AND Email = :data.email AND Profile.UserType = 'Customer Portal User'];
            system.debug('---found user--'+user);
            return user;
        }
        else    {
            if(data.attributeMap.containsKey('sfdc_networkid')) {
                //We have a community id, so create a user with community access
                //TODO: Get an actual account
                Account account;                
                try    {
                    account = [SELECT Id FROM Account WHERE Name= 'Acme'];
                }
                //throws exception if multiple match or no match
                catch(Exception e)    {
                    account = new Account();
                    account.Name = 'Acme';
                    insert account;
                }
                
                system.debug('---found account--'+account);
                
                Contact contact = new Contact();
                contact.accountId = account.Id;
                contact.email = data.email;
                contact.firstName = data.firstName;
                contact.lastName = data.lastName;
                insert(contact);
                
                system.debug('---found contact--'+contact);
                
                User user = new User();
                Profile profile = [SELECT Id FROM profile WHERE name = 'Customer Community User' ];
                user.username = data.email+ '.logitech';
                user.email = data.email;
                user.lastName = data.lastName;
                user.firstName = data.firstName;
                String alias = data.email;
                //Alias must be 8 characters or less
                if(alias.length() > 8) {
                    alias = alias.substring(0, 8);
                }
                user.alias = alias;
                user.languagelocalekey = UserInfo.getLocale();
                user.localesidkey = UserInfo.getLocale();
                user.emailEncodingKey = 'UTF-8';
                user.timeZoneSidKey = 'America/Los_Angeles';
                user.profileId = profile.Id;
                user.contactId = contact.Id;
                return user;
            } 
        else {
                //This is not a community, so create a regular standard user
                User user = new User();
                Profile profile = [SELECT Id FROM profile WHERE name='Standard User'];
                user.username = data.email+ '@myorg.com';
                user.email = data.email;
                user.lastName = data.lastName;
                user.firstName = data.firstName;
                String alias = data.email;
                //Alias must be 8 characters or less
                if(alias.length() > 8) {
                    alias = alias.substring(0, 8);
                }
                user.alias = alias;
                user.languagelocalekey = UserInfo.getLocale();
                user.localesidkey = UserInfo.getLocale();
                user.emailEncodingKey = 'UTF-8';
                user.timeZoneSidKey = 'America/Los_Angeles';
                user.profileId = profile.Id;
                setImage(user.Id,data.attributeMap.get('picture'));
                return user;
            }
            return null;
        }        
    }
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        User user = new User(id=userId);
        user.email = data.email;
        user.lastName = data.lastName;
        user.firstName = data.firstName;
        
        update(user);
    }
    
    global void setImage(Id userId, String url) {
            
        try {
            //check user's existing photo
            ConnectApi.Photo p = ConnectApi.ChatterUsers.getPhoto(null, userId);            
            // if they don't have a photo and we get a link to one
            if((p == null || p.photoVersionId == null) &&  url != null ) {            
                //retrieve the photo from google
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + Auth.AuthToken.getAccessToken('0SOe0000000000p', 'Google Login'));
                HttpResponse res = new Http().send(req);
                Blob b = res.getBodyAsBlob();                
                //set the photo on the user's profile
                ConnectApi.ChatterUsers.setPhoto(null, userId, new ConnectApi.BinaryInput(b,'image/jpg','user.jpg'));
            }
        }
        catch(Exception e){
            //don't block the user login by throwing an exception
        }
    }

}