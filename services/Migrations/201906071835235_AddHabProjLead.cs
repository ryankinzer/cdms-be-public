namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddHabProjLead : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Subproject_Hab", "ProjectLead", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Subproject_Hab", "ProjectLead");
        }
    }
}
