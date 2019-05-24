namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class new_production_fields : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.LeaseProductions", "OwnerSharePercent", c => c.Decimal(precision: 5, scale: 2));
            AddColumn("dbo.LeaseProductions", "OwnersShareUnit", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.LeaseProductions", "OwnersShareUnit");
            DropColumn("dbo.LeaseProductions", "OwnerSharePercent");
        }
    }
}
