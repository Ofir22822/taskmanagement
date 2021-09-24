using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace TaskManagementSystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //redirect from registretion after success, show message
            if (Request.QueryString["reg"] != null && Request.QueryString["reg"].ToString() == "1")
            {
                registerMsg.InnerText = "registersion succeeded";
            }
            if (Session["user"] != null)
                Response.Redirect("Tasks.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (var db = new sw_labEntities())
            {
                //select user from db, email is unique key
                var user = db.tbUsers.Where(u => u.Email == userEmail.Text).FirstOrDefault();

                if (user == null)                               //email not exist in db, no user exist
                    loginError.InnerText = "User not exist";
                else if (user.Password != userPassword.Text)    //check user password
                    loginError.InnerText = "Wrong password";
                else                                            //correct email & password, create session and go to home
                {
                    Session["user"] = user;
                    Response.Redirect("Tasks.aspx");
                }
            }
        }
    }
}