namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class nosa_fix : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.IPTDS_Detail", newName: "Arrays_Efficiency_Detail");
            RenameTable(name: "dbo.IPTDS_Header", newName: "Arrays_Efficiency_Header");
            CreateTable(
                "dbo.Feedbacks",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Title = c.String(),
                        Message = c.String(),
                        Module = c.String(),
                        SubmitterName = c.String(),
                        SubmitDate = c.DateTime(nullable: false),
                        ResponseMessage = c.String(),
                        ResponseDate = c.DateTime(),
                        Status = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.NotificationLogs",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ByUser = c.Int(nullable: false),
                        Module = c.String(),
                        Recipient = c.String(),
                        Sender = c.String(),
                        Subject = c.String(),
                        Body = c.String(),
                        SentDate = c.DateTime(nullable: false),
                        Result = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Arrays_POP_Detail",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        TRT_POPID = c.String(),
                        Estimate = c.String(),
                        StDev = c.String(),
                        LowerCI = c.String(),
                        UpperCI = c.String(),
                        RowId = c.Int(nullable: false),
                        RowStatusId = c.Int(nullable: false),
                        ActivityId = c.Int(nullable: false),
                        ByUserId = c.Int(nullable: false),
                        QAStatusId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.Activities", t => t.ActivityId)
                .ForeignKey("dbo.Users", t => t.ByUserId)
                .ForeignKey("dbo.QAStatus", t => t.QAStatusId)
                .Index(t => t.ActivityId)
                .Index(t => t.ByUserId)
                .Index(t => t.QAStatusId);
            
            CreateTable(
                "dbo.Arrays_POP_Header",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SpawnYear = c.String(),
                        Species = c.String(),
                        Run = c.String(),
                        SpeciesRun = c.String(),
                        ActivityId = c.Int(nullable: false),
                        ByUserId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .Index(t => t.ActivityId)
                .Index(t => t.ByUserId);
            
            CreateTable(
                "dbo.Arrays_Site_Detail",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SiteId = c.String(),
                        Estimate = c.String(),
                        StDev = c.String(),
                        LowerCI = c.String(),
                        UpperCI = c.String(),
                        RowId = c.Int(nullable: false),
                        RowStatusId = c.Int(nullable: false),
                        ActivityId = c.Int(nullable: false),
                        ByUserId = c.Int(nullable: false),
                        QAStatusId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.Activities", t => t.ActivityId)
                .ForeignKey("dbo.Users", t => t.ByUserId)
                .ForeignKey("dbo.QAStatus", t => t.QAStatusId)
                .Index(t => t.ActivityId)
                .Index(t => t.ByUserId)
                .Index(t => t.QAStatusId);
            
            CreateTable(
                "dbo.Arrays_Site_Header",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SpawnYear = c.String(),
                        Species = c.String(),
                        Run = c.String(),
                        SpeciesRun = c.String(),
                        ActivityId = c.Int(nullable: false),
                        ByUserId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .Index(t => t.ActivityId)
                .Index(t => t.ByUserId);
            
            AddColumn("dbo.Files", "ItemId", c => c.Int());
            AddColumn("dbo.DatasetFields", "ColumnIndex", c => c.Int());
            AddColumn("dbo.Metrics_Detail", "ReportingLevel", c => c.String());
            AddColumn("dbo.StreamNet_NOSA_Detail", "BestValue", c => c.String());
            AddColumn("dbo.StreamNet_NOSA_Detail", "OtherDataSources", c => c.String());
            AddColumn("dbo.StreamNet_NOSA_Detail", "EstimateType", c => c.String());
            AddColumn("dbo.StreamNet_NOSA_Detail", "EstimateTypeNotes", c => c.String());
            AddColumn("dbo.WaterQuality_Header", "DataSource", c => c.String());
            DropColumn("dbo.Arrays_Efficiency_Detail", "Variable");
            DropColumn("dbo.Arrays_Efficiency_Detail", "TRT_POPID");
            DropColumn("dbo.Arrays_Efficiency_Detail", "Age");
            DropColumn("dbo.Arrays_Efficiency_Detail", "CV");
            DropColumn("dbo.Arrays_Efficiency_Detail", "Mode");
            DropColumn("dbo.Arrays_Efficiency_Detail", "ValidEstimate");
            DropColumn("dbo.StreamNet_NOSA_Detail", "NOSADefinition");
        }
        
        public override void Down()
        {
            AddColumn("dbo.StreamNet_NOSA_Detail", "NOSADefinition", c => c.String());
            AddColumn("dbo.Arrays_Efficiency_Detail", "ValidEstimate", c => c.String());
            AddColumn("dbo.Arrays_Efficiency_Detail", "Mode", c => c.String());
            AddColumn("dbo.Arrays_Efficiency_Detail", "CV", c => c.String());
            AddColumn("dbo.Arrays_Efficiency_Detail", "Age", c => c.String());
            AddColumn("dbo.Arrays_Efficiency_Detail", "TRT_POPID", c => c.String());
            AddColumn("dbo.Arrays_Efficiency_Detail", "Variable", c => c.String());
            DropForeignKey("dbo.Arrays_Site_Detail", "QAStatusId", "dbo.QAStatus");
            DropForeignKey("dbo.Arrays_Site_Detail", "ByUserId", "dbo.Users");
            DropForeignKey("dbo.Arrays_Site_Detail", "ActivityId", "dbo.Activities");
            DropForeignKey("dbo.Arrays_POP_Detail", "QAStatusId", "dbo.QAStatus");
            DropForeignKey("dbo.Arrays_POP_Detail", "ByUserId", "dbo.Users");
            DropForeignKey("dbo.Arrays_POP_Detail", "ActivityId", "dbo.Activities");
            DropIndex("dbo.Arrays_Site_Header", new[] { "ByUserId" });
            DropIndex("dbo.Arrays_Site_Header", new[] { "ActivityId" });
            DropIndex("dbo.Arrays_Site_Detail", new[] { "QAStatusId" });
            DropIndex("dbo.Arrays_Site_Detail", new[] { "ByUserId" });
            DropIndex("dbo.Arrays_Site_Detail", new[] { "ActivityId" });
            DropIndex("dbo.Arrays_POP_Header", new[] { "ByUserId" });
            DropIndex("dbo.Arrays_POP_Header", new[] { "ActivityId" });
            DropIndex("dbo.Arrays_POP_Detail", new[] { "QAStatusId" });
            DropIndex("dbo.Arrays_POP_Detail", new[] { "ByUserId" });
            DropIndex("dbo.Arrays_POP_Detail", new[] { "ActivityId" });
            DropColumn("dbo.WaterQuality_Header", "DataSource");
            DropColumn("dbo.StreamNet_NOSA_Detail", "EstimateTypeNotes");
            DropColumn("dbo.StreamNet_NOSA_Detail", "EstimateType");
            DropColumn("dbo.StreamNet_NOSA_Detail", "OtherDataSources");
            DropColumn("dbo.StreamNet_NOSA_Detail", "BestValue");
            DropColumn("dbo.Metrics_Detail", "ReportingLevel");
            DropColumn("dbo.DatasetFields", "ColumnIndex");
            DropColumn("dbo.Files", "ItemId");
            DropTable("dbo.Arrays_Site_Header");
            DropTable("dbo.Arrays_Site_Detail");
            DropTable("dbo.Arrays_POP_Header");
            DropTable("dbo.Arrays_POP_Detail");
            DropTable("dbo.NotificationLogs");
            DropTable("dbo.Feedbacks");
            RenameTable(name: "dbo.Arrays_Efficiency_Header", newName: "IPTDS_Header");
            RenameTable(name: "dbo.Arrays_Efficiency_Detail", newName: "IPTDS_Detail");
        }
    }
}
