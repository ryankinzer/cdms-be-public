using NLog;
using services.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public static class DatabaseTableHelper
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void addDatasetTablesToDatabase(Datastore in_datastore)
        {
            var db = ServicesContext.Current;

            var tableName = in_datastore.TablePrefix;
            var tableName_header = in_datastore.TablePrefix + "_Header";
            var tableName_detail = in_datastore.TablePrefix + "_Detail";

            var header_query = @"
                CREATE TABLE [dbo].[" + tableName_header + @"] (
                    [Id] [int] NOT NULL IDENTITY,
                    [ActivityId] [int] NOT NULL,
                    [ByUserId] [int] NOT NULL,
                    [EffDt] [datetime] NOT NULL,
                    CONSTRAINT [PK_dbo." + tableName_header + @"] PRIMARY KEY ([Id])
                )
                CREATE INDEX [IX_ActivityId] ON [dbo].[" + tableName_header + @"]([ActivityId])
                CREATE INDEX [IX_ByUserId] ON [dbo].[" + tableName_header + @"]([ByUserId])
                ALTER TABLE [dbo].[" + tableName_header + @"] ADD CONSTRAINT [FK_dbo." + tableName_header + @"_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
                ALTER TABLE [dbo].[" + tableName_header + @"] ADD CONSTRAINT [FK_dbo." + tableName_header + @"_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])";

            logger.Debug(header_query);

            var detail_query = @"
                CREATE TABLE [dbo].[" + tableName_detail + @"] (
                    [Id] [int] NOT NULL IDENTITY,
                    [RowId] [int] NOT NULL,
                    [RowStatusId] [int] NOT NULL,
                    [ActivityId] [int] NOT NULL,
                    [ByUserId] [int] NOT NULL,
                    [QAStatusId] [int] NOT NULL,
                    [EffDt] [datetime] NOT NULL,
                    CONSTRAINT [PK_dbo." + tableName_detail + @"] PRIMARY KEY ([Id])
                )
                CREATE INDEX [IX_ActivityId] ON [dbo].[" + tableName_detail + @"]([ActivityId])
                CREATE INDEX [IX_ByUserId] ON [dbo].[" + tableName_detail + @"]([ByUserId])
                CREATE INDEX [IX_QAStatusId] ON [dbo].[" + tableName_detail + @"]([QAStatusId])
                ALTER TABLE [dbo].[" + tableName_detail + @"] ADD CONSTRAINT [FK_dbo." + tableName_detail + @"_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
                ALTER TABLE [dbo].[" + tableName_detail + @"] ADD CONSTRAINT [FK_dbo." + tableName_detail + @"_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
                ALTER TABLE [dbo].[" + tableName_detail + @"] ADD CONSTRAINT [FK_dbo." + tableName_detail + @"_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])";

            logger.Debug(detail_query);

            var header_view = @"
                CREATE VIEW " + tableName_header + @"_VW AS 
                    SELECT        *
                    FROM            dbo." + tableName_header + @" AS h
                    WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo." + tableName_header + @" AS hh
                               WHERE        (ActivityId = h.ActivityId))) ";

            logger.Debug(header_view);

            var detail_view = @"
                CREATE VIEW " + tableName_detail + @"_VW AS 
                    SELECT *
                    FROM            dbo." + tableName_detail + @" AS d
                    WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo." + tableName_detail + @" AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0) ";

            logger.Debug(detail_view);

            var main_view = @"
                CREATE VIEW " + tableName + @"_VW AS 
                SELECT        
                    a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ByUserId, h.EffDt, d.RowId, d.QAStatusId, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel,

                    d.Id AS " + tableName_detail + @"_Id, 
                    d.ByUserId AS " + tableName_detail + @"_ByUserId, 
                    d.EffDt AS " + tableName_detail + @"_EffDt

                FROM  dbo.Activities AS a INNER JOIN

                         dbo." + tableName_header + @"_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id LEFT OUTER JOIN
                         dbo." + tableName_detail + @"_VW AS d ON h.ActivityId = d.ActivityId ";

            logger.Debug(main_view);

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(header_query, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + header_query);
                        throw new Exception("Failed to execute header table create query!");
                    }
                }

                using (SqlCommand cmd = new SqlCommand(detail_query, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + detail_query);
                        throw new Exception("Failed to execute header table create query!");
                    }
                }

                using (SqlCommand cmd = new SqlCommand(header_view, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + header_view);
                        throw new Exception("Failed to execute header view create query!");
                    }
                }

                using (SqlCommand cmd = new SqlCommand(detail_view, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + detail_view);
                        throw new Exception("Failed to execute detail view create query!");
                    }
                }

                using (SqlCommand cmd = new SqlCommand(main_view, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + main_view);
                        throw new Exception("Failed to execute main view create query!");
                    }
                }


            }
        }


        public static void addSingleToDatabase(Datastore in_datastore)
        {
            var db = ServicesContext.Current;

            var tableName = in_datastore.TablePrefix;

            var table_query = @"
                CREATE TABLE [dbo].[" + tableName + @"] (
                    [Id] [int] NOT NULL IDENTITY,
                    CONSTRAINT [PK_dbo." + tableName + @"] PRIMARY KEY ([Id])
                )";

            logger.Debug(table_query);

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(table_query, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + table_query);
                        throw new Exception("Failed to execute table create query!");
                    }
                }
            }
        }

        internal static void regenerateViews(Datastore in_datastore)
        {
            var db = ServicesContext.Current;

            var tableName = in_datastore.TablePrefix;
            var tableName_header = in_datastore.TablePrefix + "_Header";
            var tableName_detail = in_datastore.TablePrefix + "_Detail";

            IEnumerable<Field> fieldList = in_datastore.Fields;

            var header_fields = "";
            var detail_fields = "";

            if(fieldList.Where(o => o.FieldRoleId == 1).Count() > 0)
                header_fields = "h." + String.Join(", h.", fieldList.Where(o => o.FieldRoleId == 1).Select(m => m.DbColumnName).ToArray());

            if (fieldList.Where(o => o.FieldRoleId == 2).Count() > 0)
                detail_fields = "d." + String.Join(", d.", fieldList.Where(o => o.FieldRoleId == 2).Select(m => m.DbColumnName).ToArray());

            List<string> fieldStrings = new List<string>() ;
            if (header_fields != "") fieldStrings.Add(header_fields);
            if (detail_fields != "") fieldStrings.Add(detail_fields);

            var fields_sql = String.Join(",", fieldStrings);
            logger.Debug(fields_sql);
            
            //note: we have to re-generate the detail and header views, too, to pick up the new column
            var header_view = @"
                ALTER VIEW " + tableName_header + @"_VW AS 
                    SELECT        *
                    FROM            dbo." + tableName_header + @" AS h
                    WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo." + tableName_header + @" AS hh
                               WHERE        (ActivityId = h.ActivityId))) ";

            logger.Debug(header_view);

            var detail_view = @"
                ALTER VIEW " + tableName_detail + @"_VW AS 
                    SELECT *
                    FROM            dbo." + tableName_detail + @" AS d
                    WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo." + tableName_detail + @" AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0) ";

            logger.Debug(detail_view);

            //now we can do the main view!
            var main_view = @"
                ALTER VIEW " + tableName + @"_VW AS 
                SELECT        
                    a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ByUserId, h.EffDt, d.RowId, d.QAStatusId, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel,
                    " + fields_sql + @", 
                    d.Id AS " + tableName_detail + @"_Id, 
                    d.ByUserId AS " + tableName_detail + @"_ByUserId, 
                    d.EffDt AS " + tableName_detail + @"_EffDt

                FROM  dbo.Activities AS a INNER JOIN

                         dbo." + tableName_header + @"_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id LEFT OUTER JOIN
                         dbo." + tableName_detail + @"_VW AS d ON h.ActivityId = d.ActivityId ";

            logger.Debug(main_view);

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand(header_view, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + header_view);
                        throw new Exception("Failed to execute header view query!");
                    }
                }

                using (SqlCommand cmd = new SqlCommand(detail_view, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + detail_view);
                        throw new Exception("Failed to execute detail view query!");
                    }
                }

                using (SqlCommand cmd = new SqlCommand(main_view, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + main_view);
                        throw new Exception("Failed to execute main view query!");
                    }
                }
            }
        }
    }
}