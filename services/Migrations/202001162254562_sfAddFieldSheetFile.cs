namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class sfAddFieldSheetFile : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.SnorkelFish_Header", "FieldSheetFile", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.SnorkelFish_Header", "FieldSheetFile");
        }
    }
}
