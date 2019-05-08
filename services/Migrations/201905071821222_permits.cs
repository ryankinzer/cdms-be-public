namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class permits : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Permits",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        AllotmentName = c.String(),
                        ProjectName = c.String(),
                        PermitNumber = c.String(),
                        PermitType = c.Int(),
                        ApplicationDate = c.DateTime(),
                        ImprovementType = c.String(),
                        IssueDate = c.DateTime(),
                        IssuedBy = c.String(),
                        ReviewedBy = c.String(),
                        ExpireDate = c.DateTime(),
                        CloseDate = c.DateTime(),
                        PermitStatus = c.String(),
                        StatusDate = c.DateTime(),
                        StatusBy = c.String(),
                        StatusNotes = c.String(),
                        PermitConditions = c.String(),
                        PermitFile = c.String(),
                        Finding = c.String(),
                        FindingDate = c.DateTime(),
                        Fee = c.Decimal(precision: 18, scale: 2),
                        FeePaymentDate = c.DateTime(),
                        FeePaymentAmount = c.Decimal(precision: 18, scale: 2),
                        FeePaymentType = c.String(),
                        FeePaymentMethod = c.String(),
                        FeePaymentReference = c.String(),
                        FeePaidBy = c.String(),
                        FeeReceivedBy = c.String(),
                        Zoning = c.String(),
                        GISUpdateRequired = c.Boolean(),
                        GISUpdateComplete = c.Boolean(),
                        Comments = c.String(),
                        SiteAddress = c.String(),
                        SquareFeet = c.String(),
                        SiteCity = c.String(),
                        SiteState = c.String(),
                        SiteZip = c.String(),
                        SiteTownship = c.String(),
                        SiteRange = c.String(),
                        SiteSection = c.String(),
                        SiteQuarter = c.String(),
                        SiteSixteenth = c.String(),
                        Valuation = c.Decimal(precision: 18, scale: 2),
                        BuildingUse = c.String(),
                        LegalDescription = c.String(),
                        IsVoid = c.Boolean(),
                        IsFloodHazardOverlay = c.Boolean(),
                        OccupationalGroup = c.String(),
                        ConstructionType = c.String(),
                        BusinessName = c.String(),
                        COStatus = c.String(),
                        COIssueDate = c.DateTime(),
                        COConditions = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.PermitEvents",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        PermitId = c.Int(nullable: false),
                        ByUser = c.Int(nullable: false),
                        EventDate = c.DateTime(nullable: false),
                        EventType = c.String(),
                        ItemType = c.String(),
                        RequestDate = c.DateTime(),
                        ResponseDate = c.DateTime(),
                        Reviewer = c.String(),
                        Result = c.String(),
                        Reference = c.String(),
                        Comments = c.String(),
                        Files = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.PermitPersons",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Organization = c.String(),
                        Prefix = c.String(),
                        FirstName = c.String(),
                        LastName = c.String(),
                        FullName = c.String(),
                        Suffix = c.String(),
                        MailingAddress1 = c.String(),
                        MailingAddress2 = c.String(),
                        MailingCity = c.String(),
                        MailingState = c.String(),
                        MailingZip = c.String(),
                        PhysicalAddress1 = c.String(),
                        PhysicalAddress2 = c.String(),
                        PhysicalCity = c.String(),
                        PhysicalState = c.String(),
                        PhysicalZip = c.String(),
                        IsMailingDifferent = c.Boolean(),
                        Phone = c.String(),
                        Cell = c.String(),
                        Fax = c.String(),
                        Email = c.String(),
                        LastUpdated = c.DateTime(),
                        UpdatedBy = c.String(),
                        Inactive = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.PermitTypes",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        Description = c.String(),
                        PermitTypeStatus = c.Int(nullable: false),
                        PermitNumberPrefix = c.String(),
                        FeeRequired = c.Double(nullable: false),
                        TemplateFile = c.String(),
                        StampRequired = c.Boolean(nullable: false),
                        InspectionsRequired = c.String(),
                        ApprovalsRequired = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.PermitTypes");
            DropTable("dbo.PermitPersons");
            DropTable("dbo.PermitEvents");
            DropTable("dbo.Permits");
        }
    }
}
