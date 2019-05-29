namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class parcels : DbMigration
    {
        public override void Up()
        {
            
            CreateTable(
                "dbo.PermitParcels",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        PermitId = c.Int(nullable: false),
                        ObjectId = c.Int(nullable: false),
                        ParcelNumber = c.String(),
                        AllotmentNumber = c.String(),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.PermitCadaster_VW", t => t.ObjectId)
                .ForeignKey("dbo.Permits", t => t.PermitId)
                .Index(t => t.PermitId)
                .Index(t => t.ObjectId);
            
            
        }
        
        public override void Down()
        {

        }
    }
}
