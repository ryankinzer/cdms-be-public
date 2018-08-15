﻿using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using services.Models;
using System.Data.Entity;
using services.Models.Data;
using services.ExtensionMethods;

/* 
 * These extension methods make it possible to use linq with ctx.SomeEntity_Header(). See below for example use.
 */
namespace services.ExtensionMethods
{
    public static class WaterTempExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<WaterTemp_Header> WaterTemp_Header(this ServicesContext ctx)
        {
            return ctx.GetDbSet("WaterTemp_Header").Cast<WaterTemp_Header>();
        }

        public static DbSet<WaterTemp_Detail> WaterTemp_Detail(this ServicesContext ctx)
        {
            return ctx.GetDbSet("WaterTemp_Detail").Cast<WaterTemp_Detail>();
        }
    }
}

namespace services.Models.Data
{
    public class WaterTemp: DatasetData
    {
        public Dataset Dataset { get; set; }
        public WaterTemp_Header Header { get; set; }
        public List<WaterTemp_Detail> Details { get; set; }

        private static Logger logger = LogManager.GetCurrentClassLogger();

        public WaterTemp() {
            Details = new List<WaterTemp_Detail>();
        }

        //load an existing one
        public WaterTemp(int ActivityId)
        { 
            
            var ndb = ServicesContext.Current;
            Details = new List<WaterTemp_Detail>();

            //select header by activityid (taking effdt into account)
            var headers_q = from h in ndb.WaterTemp_Header()
                            where h.ActivityId == ActivityId
                          join h2 in
                              (
                                  from hh in ndb.WaterTemp_Header()
                                  where hh.EffDt <= DateTime.Now
                                  where hh.ActivityId == ActivityId
                                  group hh by hh.ActivityId into cig
                                  select new { ActivityId = cig.Key, EffDt = cig.Max(ed => ed.EffDt) }
                              ) on new { h.ActivityId, h.EffDt } equals new { h2.ActivityId, h2.EffDt }
                          select h;

            //should only be 1 -- if more than one, this will give the last one.
            Header = headers_q.SingleOrDefault();

            //set the dataset now from the relationship via the activity.
            Dataset = Header.Activity.Dataset;

            //select detail by activityid (taking effdt into account)
            var details_q = (from h in ndb.WaterTemp_Detail()
                             where h.ActivityId == ActivityId
                            where h.RowStatusId == DataDetail.ROWSTATUS_ACTIVE
                            join h2 in
                                (
                                    from hh in ndb.WaterTemp_Detail()
                                    where hh.EffDt <= DateTime.Now
                                    where hh.ActivityId == ActivityId
                                    group hh by new { hh.ActivityId, hh.RowId } into cig
                                    select new { ActivityId = cig.Key.ActivityId, RowId = cig.Key.RowId, EffDt = cig.Max(ed => ed.EffDt) }
                                ) on new { h.ActivityId, h.RowId, h.EffDt } equals new { h2.ActivityId, h2.RowId, h2.EffDt }
                            select h).OrderBy(x => x.ReadingDateTime);

            foreach (var detail in details_q)
            {
                Details.Add(detail);
            }

        }

    }
}