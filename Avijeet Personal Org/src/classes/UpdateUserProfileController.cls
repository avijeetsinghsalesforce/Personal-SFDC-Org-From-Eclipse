global class UpdateUserProfileController{   
    
    public String selectedUserId {get; set;}
    public String selectedProfileId {get; set;}
    
    public List<SelectOption> getUserList() {
        List<User> users = [SELECT Id, Name, FirstName, LastName FROM User WHERE UserType =:'Standard'];
        List<SelectOption> userList = new List<SelectOption>();
        userList.add(new SelectOption('','---None---'));
        for (User user: users)    {
            userList.add(new SelectOption(user.Id,user.Name));
        }
        return userList;
    }
    
    public List<SelectOption> getProfileList() {
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE UserType =:'Standard'];
        List<SelectOption> profileList = new List<SelectOption>();
        profileList.add(new SelectOption('','---None---'));
        for (Profile profile: profiles)    {
            profileList.add(new SelectOption(profile.Id,profile.Name));
        }
        return profileList;
    }
    
    public PageReference updateUser() {
        if ((selectedUserId !=null)&&(selectedProfileId !=null))    {
            User user = [SELECT ProfileId FROM User WHERE Id=:selectedUserId];
            user.ProfileId = selectedProfileId;
            try{
                update user;
            }
            catch(Exception e)    {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
                return null;
            }
            
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
        }
        else    {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select user and profile both to proceed'));
            return null;
        }
        return null;
    }
}