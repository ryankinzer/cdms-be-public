namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddOlcSubprojectAndEvent : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Subproject_OLC",
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
                "dbo.OLCEvents",
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
                        Comments = c.String(),
                        FileAttach = c.String(),
                        ByUserId = c.Int(nullable: false),
                        EffDt = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.Subproject_OLC", t => t.SubprojectId)
                .Index(t => t.SubprojectId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.OLCEvents", "SubprojectId", "dbo.Subproject_OLC");
            DropIndex("dbo.OLCEvents", new[] { "SubprojectId" });
            DropTable("dbo.OLCEvents");
            DropTable("dbo.Subproject_OLC");
        }
    }
}
