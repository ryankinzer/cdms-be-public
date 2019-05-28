namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class add_columnindex : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Subproject_Olc",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CatalogNumber = c.String(),
                        RecordGroup = c.String(),
                        SeriesTitle = c.String(),
                        FacilityHoused = c.String(),
                        Box = c.String(),
                        BoxLocation = c.String(),
                        CategoryTitle = c.String(),
                        CategoryIndex = c.String(),
                        SignatoryTitle = c.String(),
                        SignatoryAgency = c.String(),
                        SignatoryName = c.String(),
                        ByUserId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.OlcEvents",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SubprojectId = c.Int(nullable: false),
                        DocumentType = c.String(),
                        DocumentDate = c.DateTime(),
                        FileName = c.String(),
                        Author = c.String(),
                        AuthorAgency = c.String(),
                        Boundary = c.String(),
                        SignificantArea = c.String(),
                        MiscelleneousContext = c.String(),
                        Description = c.String(),
                        TwnRngSec = c.String(),
                        NumberItems = c.Int(),
                        DateDiscovered = c.DateTime(),
                        PersonDiscovered = c.String(),
                        Reference = c.String(),
                        EventComments = c.String(),
                        FileAttach = c.String(),
                        ByUserId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.Subproject_Olc", t => t.SubprojectId)
                .Index(t => t.SubprojectId);
            
            AddColumn("dbo.DatasetFields", "ColumnIndex", c => c.Int());
            AddColumn("dbo.LeaseProductions", "OwnerSharePercent", c => c.Decimal(precision: 5, scale: 2));
            AddColumn("dbo.LeaseProductions", "OwnerShareDollar", c => c.Decimal(precision: 9, scale: 2));
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.OlcEvents", "SubprojectId", "dbo.Subproject_Olc");
            DropIndex("dbo.OlcEvents", new[] { "SubprojectId" });
            DropColumn("dbo.LeaseProductions", "OwnerShareDollar");
            DropColumn("dbo.LeaseProductions", "OwnerSharePercent");
            DropColumn("dbo.DatasetFields", "ColumnIndex");
            DropTable("dbo.OlcEvents");
            DropTable("dbo.Subproject_Olc");
        }
    }
}
