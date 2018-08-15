﻿using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using services.ExtensionMethods;

/*
 * insert into Fields (FieldCategoryId, Name, Description, Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType)
select 6, Name, Description, Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType from Fields 
WHERE DbColumnName in ('Sex','RunYear','Origin','LifeStage','FinClip','Disposition','Species','Tag','ReleaseSite')
 * */


/* 
 * These extension methods make it possible to use linq with ctx.SomeEntity_Header(). See below for example use.
 */ 
namespace services.ExtensionMethods
{
    public static class ArtificialProductionExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<ArtificialProduction_Header> ArtificialProduction_Header(this ServicesContext ctx)
        {
            return ctx.GetDbSet("ArtificialProduction_Header").Cast<ArtificialProduction_Header>();
        }

        public static DbSet<ArtificialProduction_Detail> ArtificialProduction_Detail(this ServicesContext ctx)
        {
            return ctx.GetDbSet("ArtificialProduction_Detail").Cast<ArtificialProduction_Detail>();
        }
    }
}


namespace services.Models.Data
{
    public class ArtificialProduction : DatasetData
    {
        public Dataset Dataset { get; set; }
        public ArtificialProduction_Header Header { get; set; }
        public List<ArtificialProduction_Detail> Details { get; set; }

        public ArtificialProduction()
        {
            Details = new List<ArtificialProduction_Detail>();
        }

        //load an existing one
        public ArtificialProduction(int ActivityId)
        {

            var ndb = ServicesContext.Current;
            Details = new List<ArtificialProduction_Detail>();

            //select header by activityid (taking effdt into account)
            var headers_q = from h in ndb.ArtificialProduction_Header()
                            where h.ActivityId == ActivityId
                            join h2 in
                                (
                                    from hh in ndb.ArtificialProduction_Header()
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
            var details_q = from h in ndb.ArtificialProduction_Detail()
                            where h.ActivityId == ActivityId
                            where h.RowStatusId == DataDetail.ROWSTATUS_ACTIVE
                            join h2 in
                                (
                                    from hh in ndb.ArtificialProduction_Detail()
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