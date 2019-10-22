namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CDMS_21_DatabaseUpdates : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Feedbacks",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Title = c.String(),
                        Message = c.String(),
                        Module = c.String(),
                        SubmitterName = c.String(),
                        SubmitDate = c.DateTime(nullable: false),
                        ResponseMessage = c.String(),
                        ResponseDate = c.DateTime(),
                        Status = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.NotificationLogs",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ByUser = c.Int(nullable: false),
                        Module = c.String(),
                        Recipient = c.String(),
                        Sender = c.String(),
                        Subject = c.String(),
                        Body = c.String(),
                        SentDate = c.DateTime(nullable: false),
                        Result = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.Files", "ItemId", c => c.Int());
            AddColumn("dbo.DatasetFields", "ColumnIndex", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.DatasetFields", "ColumnIndex");
            DropColumn("dbo.Files", "ItemId");
            DropTable("dbo.NotificationLogs");
            DropTable("dbo.Feedbacks");
        }
    }
}
