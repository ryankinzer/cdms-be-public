using System;
using System.Collections.Generic;
using System.Linq;
using NLog; // For the logger.Debug

using services.Models;
using System.Data.Entity;
using services.Models.Data;
using services.ExtensionMethods;

/* 
 * These extension methods make it possible to use linq with ctx.SomeEntity_Header(). See below for example use.
 */
namespace services.ExtensionMethods
{
    public static class RST_DataExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<RST_Data_Header> RST_Data_Header(this ServicesContext ctx)
        {
            return ctx.GetDbSet("RST_Data_Header").Cast<RST_Data_Header>();
        }

        public static DbSet<RST_Data_Detail> RST_Data_Detail(this ServicesContext ctx)
        {
            return ctx.GetDbSet("RST_Data_Detail").Cast<RST_Data_Detail>();
        }
    }
}


namespace services.Models.Data
{
    public class RST_Data : DatasetData
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public Dataset Dataset { get; set; }
        public RST_Data_Header Header { get; set; }
        public List<RST_Data_Detail> Details { get; set; }

        public RST_Data()
        {
            Details = new List<RST_Data_Detail>();
        }


        // load an existing one
        public RST_Data(int ActivityId)
        {
            var ndb = ServicesContext.Current;
            Details = new List<RST_Data_Detail>();

            var headers_q = from h in ndb.RST_Data_Header()
                            where h.ActivityId == ActivityId
                            join h2 in
                                (
                                    from hh in ndb.RST_Data_Header()
                                    where hh.EffDt <= DateTime.Now
                                    where hh.ActivityId == ActivityId
                                    group hh by hh.ActivityId into cig
                                    select new { ActivityId = cig.Key, EffDt = cig.Max(ed => ed.EffDt) }
                                ) on new { h.ActivityId, h.EffDt } equals new { h2.ActivityId, h2.EffDt }
                            select h;

            Header = headers_q.SingleOrDefault();

            Dataset = Header.Activity.Dataset;

            //select detail by activityid (taking effdt into account)
            var details_q = from h in ndb.RST_Data_Detail()
                            where h.ActivityId == ActivityId
                            where h.RowStatusId == DataDetail.ROWSTATUS_ACTIVE
                            join h2 in
                                (
                                    from hh in ndb.RST_Data_Detail()
                                    where hh.EffDt <= DateTime.Now
                                    where hh.ActivityId == ActivityId
                                    group hh by new { hh.ActivityId, hh.RowId } into cig
                                    select new { ActivityId = cig.Key.ActivityId, RowId = cig.Key.RowId, EffDt = cig.Max(ed => ed.EffDt) }
                                ) on new { h.ActivityId, h.RowId, h.EffDt } equals new { h2.ActivityId, h2.RowId, h2.EffDt }
                            select h;

            foreach (var detail in details_q)
            {
                Details.Add(detail);
            }
        }
    }
}