namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class permitcontact : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.PermitContacts",
                c => new
                    {
                        PermitId = c.Int(nullable: false),
                        PermitPersonId = c.Int(nullable: false),
                        IsPrimary = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.PermitId, t.PermitPersonId })
                .ForeignKey("dbo.Permits", t => t.PermitId)
                .ForeignKey("dbo.PermitPersons", t => t.PermitPersonId)
                .Index(t => t.PermitId)
                .Index(t => t.PermitPersonId);
            
           
        }
        
        public override void Down()
        {
            
        }
    }
}
