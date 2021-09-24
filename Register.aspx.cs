using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TaskManagementSystem
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            btnUpdate.Visible = false;
            registerMsg.Text = "";
            userPassword.TextMode = TextBoxMode.Password;

            if ((Session["user"] != null) && Request.QueryString["up"] != null && Request.QueryString["up"].ToString() == "1" && Session["user"]!=null)
            {
                Page.Title = "User Details";
                cardTitle.InnerText = "User Details";
                btnCreate.Visible = false;
                btnUpdate.Visible = true;
                userPassword.TextMode = TextBoxMode.SingleLine;

                if (!IsPostBack)
                {
                    tbUsers userLogged = ((tbUsers)Session["user"]);
                    userFirstName.Text = userLogged.FirstName;
                    userLastName.Text = userLogged.LastName;
                    userEmail.Text = userLogged.Email;
                    userEmail.ReadOnly = true;
                    userPassword.Text = userLogged.Password;
                    userUsername.Text = userLogged.Username;
                }
            }
            else if (Session["user"] != null)
                Response.Redirect("Tasks.aspx");
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            using (var db = new sw_labEntities())
            {
                int result = 0;
                var user = new tbUsers()
                {
                    Email = userEmail.Text,
                    Password = userPassword.Text,
                    FirstName = userFirstName.Text,
                    LastName = userLastName.Text,
                    Username = userUsername.Text
                };
                try
                {
                    var userCheck = db.tbUsers.Where(u => u.Email == userEmail.Text).FirstOrDefault();
                    if (userCheck != null)
                    {
                        userEmailError.IsValid = false;
                        userEmail.CssClass += " is-invalid";
                        userEmailError.Text = "Email already exist \n";
                    }
                    else
                    {
                        db.tbUsers.Add(user);
                        result = db.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    registerMsg.Text = "register error, try again \n";
                }
                if (result != 0)    //registretion success, go to login page
                {
                    Response.Redirect("login.aspx?reg=1");
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            using (var db = new sw_labEntities())
            {
                tbUsers userLogged = (tbUsers)Session["user"];
                tbUsers user = db.tbUsers.Where(u => u.Email == userLogged.Email).FirstOrDefault();                 //get logged user data from db

                user.FirstName = userFirstName.Text;
                user.LastName = userLastName.Text;     
                user.Password = userPassword.Text;
                user.Username = userUsername.Text;

                int result = db.SaveChanges();      //save changes in db
                Session["user"] = user;
            }

            registerMsg.CssClass = "mt-auto mb-auto text-success d-inline";
            registerMsg.Text = "user details updated";
        }

        }
}