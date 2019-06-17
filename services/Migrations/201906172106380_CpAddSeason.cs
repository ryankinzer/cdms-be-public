namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CpAddSeason : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.CreelPhone_Header", "Season", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.CreelPhone_Header", "Season");
        }
    }
}
