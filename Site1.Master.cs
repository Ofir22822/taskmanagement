using System;
using System.Data.SqlClient;
using System.Text;

namespace TaskManagementSystem
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user"] != null)
            {
                userLogged.Visible = true;
                var User = (tbUsers)Session["user"];
                userMsg.InnerText = "Welcome " + User.FirstName + " " + User.LastName;
            }
            else
            {
                userLogged.Visible = false;
                userMsg.InnerText = "Hello Guest";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
        protected void btnUserUpdate_Click(object sender, EventArgs e)
        {
            Response.Redirect("register.aspx?up=1");
        }
    }
}