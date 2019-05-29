using services.ExtensionMethods;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace services.Controllers.Private
{
    [System.Web.Http.Authorize]
    public class PermitController : CDMSController
    {

        public static string ROLE_REQUIRED = "Permits";

        [HttpGet]
        public dynamic AllPermits()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.Permit().Where(o => o.PermitStatus != "Archived").OrderByDescending(o => o.ApplicationDate).Take(100).AsEnumerable(); //TODO just getting 100 for now

        }


        [HttpGet]
        public dynamic GetPermitContacts(int Id)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.PermitContacts().Where(o => o.PermitId == Id).AsEnumerable();

        }


    }
}
