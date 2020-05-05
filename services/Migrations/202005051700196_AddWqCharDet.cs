namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddWqCharDet : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.WaterQuality_Detail", "CharactDetected", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.WaterQuality_Detail", "CharactDetected");
        }
    }
}
