using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NLog;
using services.Models;

namespace services.Resources
{
    public static class AuthorizationManager
    {
        public const string CURRENT_USERNAME_KEY = "CURRENT_USERNAME";

        public const int VIEW_PERMISSION = 1;
        public const int EDIT_PERMISSION = 2;
        public const int OWNER_PERMISSION = 3;

        public const int PROJECT_ENTITY = 1;
        public const int DATASET_ENTITY = 2;

        private static Logger logger = LogManager.GetCurrentClassLogger();

        private static bool CanViewAny = true;

        /**
         * is a user authorized for this entity permission (VIEW, PROJECT, 17)?
         * 
         */
        public static bool IsUserAuthorized(User user, int permission, int entity, int targetId)
        {
            if (CanViewAny && permission == 1)
                return true;
            logger.Debug("Checking authorization: " + user.Username + " - " + entity + " - " + targetId);
            bool isAuth = true; /*user.Permissions.Where(p => p.PermissionTypeId >= permission &&
                                               p.EntityTypeId == entity &&
                                               p.EntityRowId == targetId).Any();
                           */ 

            //throw new Exception(user.Id + " - " + permission + " - " + entity + " - " + targetId + " - result = " + isAuth);
            return isAuth;

        }

        public static bool IsUsernameAuthorized(string username, int permission, int entity, int targetId)
        {
            return IsUserAuthorized(getUserByName(username), permission, entity, targetId);
        }

        public static bool IsCurrentUserAuthorized(int permission, int entity, int targetId)
        {
            return IsUsernameAuthorized(HttpContext.Current.User.Identity.Name, permission, entity, targetId);
        }

        public static User getUserByName(string Username)
        {
            User user = null;

            try
            {
                var db = ServicesContext.Current;
                user = db.User.SingleOrDefault(x => x.Username == Username);
            }catch(Exception e){
                logger.Debug("problem fetching that user: " + Username);
                logger.Debug(e.InnerException);
            }

            return user;
        }

        public static User getCurrentUser()
        {
            logger.Debug("Inside AuthorizationManager, getCurrentUser");

            string strCurrentUserName = HttpContext.Current.User.Identity.Name;
            //logger.Debug(" >> current user = " + HttpContext.Current.User.Identity.Name);
            logger.Debug(" >> current user = " + strCurrentUserName);

            int intBackSlashLocation = strCurrentUserName.IndexOf("\\");
            if (intBackSlashLocation > -1)
            {
                strCurrentUserName = strCurrentUserName.Substring(intBackSlashLocation + 1);
                logger.Debug("Cleaned userName = " + strCurrentUserName);
            }

            //User me = getUserByName(HttpContext.Current.User.Identity.Name);
            User me = getUserByName(strCurrentUserName);

            if(me == null)
                logger.Debug("user is NULL -- not valid.");
            else {
                 logger.Debug("have our user: " + me.Username); 
            }

            return me;
        }

    }
}