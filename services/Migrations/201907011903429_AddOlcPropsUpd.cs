namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddOlcPropsUpd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Subproject_Olc", "Agency", c => c.String());
            AddColumn("dbo.Subproject_Olc", "AgencyLocation", c => c.String());
            AddColumn("dbo.Subproject_Olc", "CategorySubtitle", c => c.String());
            AddColumn("dbo.OlcEvents", "SignatoryTitle", c => c.String());
            AddColumn("dbo.OlcEvents", "SignatoryName", c => c.String());
            AddColumn("dbo.OlcEvents", "AgencyDivision", c => c.String());
            AddColumn("dbo.OlcEvents", "RecipientName", c => c.String());
            AddColumn("dbo.OlcEvents", "RecipientTitle", c => c.String());
            AddColumn("dbo.OlcEvents", "RecipientAgency", c => c.String());
            AddColumn("dbo.OlcEvents", "RecipientLocation", c => c.String());
            AddColumn("dbo.OlcEvents", "SurveyNumber", c => c.String());
            AddColumn("dbo.OlcEvents", "SurveyContractNumber", c => c.String());
            AddColumn("dbo.OlcEvents", "SurveyorName", c => c.String());
            AddColumn("dbo.OlcEvents", "SurveyAuthorizingAgency", c => c.String());
            AddColumn("dbo.OlcEvents", "SurveyDates", c => c.String());
            AddColumn("dbo.OlcEvents", "Tasks", c => c.String());
            DropColumn("dbo.Subproject_Olc", "CatalogNumber");
            DropColumn("dbo.Subproject_Olc", "BoxLocation");
            DropColumn("dbo.Subproject_Olc", "CategoryIndex");
            DropColumn("dbo.Subproject_Olc", "SignatoryTitle");
            DropColumn("dbo.Subproject_Olc", "SignatoryAgency");
            DropColumn("dbo.Subproject_Olc", "SignatoryName");
            DropColumn("dbo.OlcEvents", "AuthorAgency");
            DropColumn("dbo.OlcEvents", "EventComments");
        }
        
        public override void Down()
        {
            AddColumn("dbo.OlcEvents", "EventComments", c => c.String());
            AddColumn("dbo.OlcEvents", "AuthorAgency", c => c.String());
            AddColumn("dbo.Subproject_Olc", "SignatoryName", c => c.String());
            AddColumn("dbo.Subproject_Olc", "SignatoryAgency", c => c.String());
            AddColumn("dbo.Subproject_Olc", "SignatoryTitle", c => c.String());
            AddColumn("dbo.Subproject_Olc", "CategoryIndex", c => c.String());
            AddColumn("dbo.Subproject_Olc", "BoxLocation", c => c.String());
            AddColumn("dbo.Subproject_Olc", "CatalogNumber", c => c.String());
            DropColumn("dbo.OlcEvents", "Tasks");
            DropColumn("dbo.OlcEvents", "SurveyDates");
            DropColumn("dbo.OlcEvents", "SurveyAuthorizingAgency");
            DropColumn("dbo.OlcEvents", "SurveyorName");
            DropColumn("dbo.OlcEvents", "SurveyContractNumber");
            DropColumn("dbo.OlcEvents", "SurveyNumber");
            DropColumn("dbo.OlcEvents", "RecipientLocation");
            DropColumn("dbo.OlcEvents", "RecipientAgency");
            DropColumn("dbo.OlcEvents", "RecipientTitle");
            DropColumn("dbo.OlcEvents", "RecipientName");
            DropColumn("dbo.OlcEvents", "AgencyDivision");
            DropColumn("dbo.OlcEvents", "SignatoryName");
            DropColumn("dbo.OlcEvents", "SignatoryTitle");
            DropColumn("dbo.Subproject_Olc", "CategorySubtitle");
            DropColumn("dbo.Subproject_Olc", "AgencyLocation");
            DropColumn("dbo.Subproject_Olc", "Agency");
        }
    }
}
