using services.ExtensionMethods;
using services.Models;
using services.Models.Data;
using System.Collections.Generic;
using System.Linq;

namespace services.Resources.Notifiers.Helpers
{
    class PermitRouteHelper
    {
        public static List<string> getRecipientsForRoute(string in_eventtype, string in_itemtype ) {
            var db = ServicesContext.Current;

            List<string> retval = new List<string>();

            retval = db.PermitRoute().Where(o => o.EventType == in_eventtype && o.ItemType == in_itemtype).Select(o => o.Email).ToList<string>();

            return retval;
        }
    }
}