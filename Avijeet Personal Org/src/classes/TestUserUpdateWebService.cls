global class TestUserUpdateWebService    {
    webservice static void updateUser()    {
        User user = [SELECT ProfileId FROM User WHERE Id=:'00590000001Dbyk'];
        user.ProfileId = '00e90000001M4I8';
        update user;
    }
}