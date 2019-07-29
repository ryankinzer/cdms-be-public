using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace services.ExtensionMethods
{
    public static class PermitRouteExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitRoute> PermitRoute (this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitRoute").Cast<PermitRoute>();
        }
    }
}


namespace services.Models.Data
{
    public class PermitRoute : DataEntity
    {
        public int Id { get; set; }
        public string EventType { get; set; }
        public string ItemType { get; set; }
        public int Rank { get; set; }
        public string Email { get; set; }

    }
}