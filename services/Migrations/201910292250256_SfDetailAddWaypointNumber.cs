namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SfDetailAddWaypointNumber : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.SnorkelFish_Detail", "WaypointNumber", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.SnorkelFish_Detail", "WaypointNumber");
        }
    }
}
