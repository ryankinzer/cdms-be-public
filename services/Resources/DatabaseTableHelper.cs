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


    }
}