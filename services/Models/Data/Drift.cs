﻿using System;
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
    public static class DriftExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Drift_Header> Drift_Header(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Drift_Header").Cast<Drift_Header>();
        }

        public static DbSet<Drift_Detail> Drift_Detail(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Drift_Detail").Cast<Drift_Detail>();
        }
    }
}
namespace services.Models.Data
{
    public class Drift : DatasetData
    {
        private Boolean debugMode = true;
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public Dataset Dataset { get; set; }
        public Drift_Header Header { get; set; }
        public List<Drift_Detail> Details { get; set; }

        public Drift()
        {
            Details = new List<Drift_Detail>();
        }


        // load an existing one
        public Drift(int ActivityId)
        {
            var db = ServicesContext.Current;
            if (debugMode) logger.Info("db = " + db);
            Details = new List<Drift_Detail>();

            //select header by activityid (taking effdt into account)
            var headers_q = from h in db.Drift_Header()
                            where h.ActivityId == ActivityId
                            join h2 in
                                (
                                    from hh in db.Drift_Header()
                                    where hh.EffDt <= DateTime.Now
                                    where hh.ActivityId == ActivityId
                                    group hh by hh.ActivityId into cig
                                    select new { ActivityId = cig.Key, EffDt = cig.Max(ed => ed.EffDt) }
                                ) on new { h.ActivityId, h.EffDt } equals new { h2.ActivityId, h2.EffDt }
                            select h;
            //if (debugMode) logger.Info("headers_q = " + headers_q);

            //should only be 1 -- if more than one, this will give the last one.
            //if (debugMode) logger.Info("Header is next...");
            Header = headers_q.SingleOrDefault();
            if (debugMode) logger.Info("Header = " + Header);

            //set the dataset now from the relationship via the activity.
            //if (debugMode) logger.Info("Dataset is next...");
            Dataset = Header.Activity.Dataset;
            if (debugMode) logger.Info("Dataset = " + Dataset);

            //select detail by activityid (taking effdt into account)
            var details_q = from h in db.Drift_Detail()
                            where h.ActivityId == ActivityId
                            where h.RowStatusId == DataDetail.ROWSTATUS_ACTIVE
                            join h2 in
                                (
                                    from hh in db.Drift_Detail()
                                    where hh.EffDt <= DateTime.Now
                                    where hh.ActivityId == ActivityId
                                    group hh by new { hh.ActivityId, hh.RowId } into cig
                                    select new { ActivityId = cig.Key.ActivityId, RowId = cig.Key.RowId, EffDt = cig.Max(ed => ed.EffDt) }
                                ) on new { h.ActivityId, h.RowId, h.EffDt } equals new { h2.ActivityId, h2.RowId, h2.EffDt }
                            select h;
            //if (debugMode) logger.Info("details_q = " + details_q);

            foreach (var detail in details_q)
            {
                //if (debugMode) logger.Info("About to add " + detail + " to Datails...");
                Details.Add(detail);
                //if (debugMode) logger.Info("Added the detail...");
            }
            if (debugMode) logger.Info("Details = " + Details);
        }
    }
}