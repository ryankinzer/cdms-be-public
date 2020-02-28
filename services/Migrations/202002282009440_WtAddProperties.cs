namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class WtAddProperties : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.WaterTemp_Detail", "MinWaterTemperature", c => c.Double());
            AddColumn("dbo.WaterTemp_Detail", "MaxWaterTemperature", c => c.Double());
            AddColumn("dbo.WaterTemp_Detail", "MeanWaterTemperature", c => c.Double());
            AddColumn("dbo.WaterTemp_Detail", "MinAirTemperature", c => c.Double());
            AddColumn("dbo.WaterTemp_Detail", "MaxAirTemperature", c => c.Double());
            AddColumn("dbo.WaterTemp_Detail", "MeanAirTemprature", c => c.Double());
        }
        
        public override void Down()
        {
            DropColumn("dbo.WaterTemp_Detail", "MeanAirTemprature");
            DropColumn("dbo.WaterTemp_Detail", "MaxAirTemperature");
            DropColumn("dbo.WaterTemp_Detail", "MinAirTemperature");
            DropColumn("dbo.WaterTemp_Detail", "MeanWaterTemperature");
            DropColumn("dbo.WaterTemp_Detail", "MaxWaterTemperature");
            DropColumn("dbo.WaterTemp_Detail", "MinWaterTemperature");
        }
    }
}
