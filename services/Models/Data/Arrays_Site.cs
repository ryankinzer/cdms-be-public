﻿using System;
using System.Collections.Generic;
using System.Linq;
using services.Models;
using System.Data.Entity;
using services.Models.Data;
using services.ExtensionMethods;

/* 
 * These extension methods make it possible to use linq with ctx.SomeEntity_Header(). See below for example use.
 */
namespace services.ExtensionMethods
{
    public static class Arrays_SiteExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Arrays_Site_Header> Arrays_Site_Header(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Arrays_Site_Header").Cast<Arrays_Site_Header>();
        }

        public static DbSet<Arrays_Site_Detail> Arrays_Site_Detail(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Arrays_Site_Detail").Cast<Arrays_Site_Detail>();
        }
    }
}

namespace services.Models.Data
{
    public class Arrays_Site : DatasetData
    {
        public Dataset Dataset { get; set; }
        public Arrays_Site_Header Header { get; set; }
        public List<Arrays_Site_Detail> Details { get; set; }

        public Arrays_Site()
        {
            Details = new List<Arrays_Site_Detail>();
        }


        // load an existing one
        public Arrays_Site(int ActivityId)
        {
            var ndb = ServicesContext.Current;
            Details = new List<Arrays_Site_Detail>();

            //select header by activityid (taking effdt into account)
            var headers_q = from h in ndb.Arrays_Site_Header()
                            where h.ActivityId == ActivityId
                            join h2 in
                                (
                                    from hh in ndb.Arrays_Site_Header()
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
            var details_q = from h in ndb.Arrays_Site_Detail()
                            where h.ActivityId == ActivityId
                            where h.RowStatusId == DataDetail.ROWSTATUS_ACTIVE
                            join h2 in
                                (
                                    from hh in ndb.Arrays_Site_Detail()
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