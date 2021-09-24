using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TaskManagementSystem
{
    public partial class Tasks : System.Web.UI.Page
    {
        private int userID;
        private String m_strSortExp = String.Empty;
        private SortDirection m_SortDirection = SortDirection.Ascending;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user"] == null)
                Response.Redirect("Login.aspx");

            userID = ((tbUsers)Session["user"]).UserID;
            if (!IsPostBack)
            {
                FillGrid(1, userID);        //fill grid with task data
                FillSummery(userID);
                repeaterSummeryBind();      //fill tasks summery list 
                ViewState["tab"] = "ToDo";  //set selected tab to ToDo
                displayPageState();
            }
            else
            {
                //check viewstate for sorting of tasks
                if (null != ViewState["_SortExp_"])
                    m_strSortExp = ViewState["_SortExp_"] as String;
                if (null != ViewState["_Direction_"])
                    m_SortDirection = (SortDirection)ViewState["_Direction_"];
            }
            
        }

        /*gridview functions*/
        private void BindDataToGridView()
        {
            gvData.DataSource = ((IEnumerable<tbTasks>)Session["data"]).ToList();       //set data source of gridview
            gvData.DataBind();                                                          //bind data to gridview
        }

        //fill gridview with data from databse, will select task of user with id = userID, and only task with status = taskStatus
        private void FillGrid(int taskStatus, int userID)
        {
            using (var db = new sw_labEntities())
            {
                tbUsers user = db.tbUsers.Where(u => u.UserID == userID).FirstOrDefault(); //select user
                var taskTODOtable = user.tbTasks.Where(t => t.Status == taskStatus).OrderByDescending(t => t.ToDate);       //select user tasks
                Session["data"] = taskTODOtable;                                           //save data in session
                BindDataToGridView();                                                      //bind data
            }
        }


        //for gridview sorting
        public SortDirection GridViewSortDirection
        {
            get
            {
                if (ViewState["sortDirection"] == null)
                    ViewState["sortDirection"] = SortDirection.Ascending;

                return (SortDirection)ViewState["sortDirection"];
            }
            set { ViewState["sortDirection"] = value; }
        }

        //sorting function for gridview
        protected void gvData_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (String.Empty != m_strSortExp)   //check if already sorted by expression
            {
                if (String.Compare(e.SortExpression, m_strSortExp, true) == 0)      //check what expression is sorted by, if same value change direction of sorting
                {
                    m_SortDirection = (m_SortDirection == SortDirection.Ascending) ? SortDirection.Descending : SortDirection.Ascending;    //change direction of sorted by
                }
            }

            ViewState["_Direction_"] = m_SortDirection;                 //save state of sort by direction and expression
            ViewState["_SortExp_"] = m_strSortExp = e.SortExpression;

            if (m_SortDirection == SortDirection.Ascending)             //order data by direction, and save in session
            {
                switch (m_strSortExp)
                {
                    case "Title":
                        Session["data"] = ((IEnumerable<tbTasks>)Session["data"]).OrderBy(t => t.Title).ToList();
                        break;
                    case "Date":
                        Session["data"] = ((IEnumerable<tbTasks>)Session["data"]).OrderBy(t => t.ToDate).ToList();
                        break;
                    case "Priority":
                        Session["data"] = ((IEnumerable<tbTasks>)Session["data"]).OrderBy(t => t.Priority).ToList();
                        break;
                }
            }
            else
            {
                switch (m_strSortExp)
                {
                    case "Title":
                        Session["data"] = ((IEnumerable<tbTasks>)Session["data"]).OrderByDescending(t => t.Title).ToList();
                        break;
                    case "Date":
                        Session["data"] = ((IEnumerable<tbTasks>)Session["data"]).OrderByDescending(t => t.ToDate).ToList();
                        break;
                    case "Priority":
                        Session["data"] = ((IEnumerable<tbTasks>)Session["data"]).OrderByDescending(t => t.Priority).ToList();
                        break;
                }
            }

            BindDataToGridView();
        }

        //function for pager on index change
        protected void gvData_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvData.PageIndex = e.NewPageIndex;
            BindDataToGridView();
            displayPageState();
        }


        /*Summerys repeaters functions*/
        private void FillSummery(int userID)
        {
            using (var db = new sw_labEntities())
            {
                tbUsers user = db.tbUsers.Where(u => u.UserID == userID).FirstOrDefault(); //select user
                var taskSummerytable = user.tbTasks.Where(t => t.Status == 1 && t.ToDate >= DateTime.Today && t.ToDate < DateTime.Today.AddDays(7)).OrderByDescending(t => t.ToDate);       //select user summery tasks
                Session["summery"] = taskSummerytable;           //save summery data in session
                repeaterSummeryBind();                           //bind data
            }
        }

        protected void repeaterSummeryBind()
        {
            //today tasks
            List<tbTasks> todaySummeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList().FindAll(t => t.ToDate == DateTime.Today);
            rptTodaySummery.DataSource = todaySummeryList;
            rptTodaySummery.DataBind();

            //next 7 days tasks
            List<tbTasks> NextDayTasksId = ((IEnumerable<tbTasks>)Session["summery"]).ToList().FindAll(t => t.ToDate > DateTime.Today && t.ToDate < DateTime.Today.AddDays(7));
            rptNextSummery.DataSource = NextDayTasksId;
            rptNextSummery.DataBind();
        }

        //run scripts to display page according to viewstate
        private void displayPageState()
        {
            //if not null, add sorting icon to button with jquery script
            if (ViewState["sortType"] != null)
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "sortImg", "sortIcon('" + ViewState["sortType"] + "', '" + m_SortDirection + "');", true);
            //css select tab with jquery script
            ScriptManager.RegisterStartupScript(this, this.GetType(), "tabChange", "tabChange('" + ViewState["tab"].ToString() + "');", true);
        }

        /*buttons functions*/

        //button click for sort by expression
        protected void btnTaskSortBy_Click(object sender, EventArgs e)
        {
            LinkButton btnSortBy = (LinkButton)sender;
            //sort gridview, CommandArgument = sort expression
            gvData_Sorting(gvData, new GridViewSortEventArgs(btnSortBy.CommandArgument, SortDirection.Ascending));

            ViewState["sortType"] = btnSortBy.CommandArgument;      //save current sorting type
            displayPageState();
        }
        protected void btnTabChange(object sender, EventArgs e)
        {
            Button btn = (Button)sender;

            ViewState["sortType"] = null;       //delete sorting state from previous tab
            switch (btn.CommandArgument)
            {
                case "ToDo":
                    FillGrid(1, userID);        //fill grid with tasks with status = 1(todo), of user with id = userid
                    ViewState["tab"] = "ToDo";  //save current tab
                    break;
                case "Done":
                    FillGrid(2, userID);
                    ViewState["tab"] = "Done";
                    break;
                case "Archive":
                    FillGrid(3, userID);
                    ViewState["tab"] = "Archive";
                    break;
            }
            displayPageState();
        }

        /*buttons*/

        //create new task in db
        protected void btnCreate_Click(object sender, EventArgs e)
        {
            tbTasks newTask = new tbTasks();    //create new task variable 

            newTask.Title = mdlTitle.Text;      //set details of new task from modal
            newTask.Details = mdlDetails.Text;
            newTask.ToDate = DateTime.Parse(mdlDueDate.Text);
            newTask.Priority = short.Parse(mdlPriority.SelectedValue);
            newTask.Status = 1;                 //status 1 = ToDo

            using (var db = new sw_labEntities())
            {
                var newTbTask = new tbTasks()    //create new task for db
                {
                    Title = newTask.Title,
                    Priority = short.Parse(newTask.Priority.ToString()),
                    Status = short.Parse(newTask.Status.ToString()),
                    Details = newTask.Details,
                    ToDate = newTask.ToDate,
                };
                tbUsers user = (tbUsers)Session["user"];                                //logged user data in session
                user = db.tbUsers.Where(u => u.Email == user.Email).FirstOrDefault();   //get logged user data from db
                user.tbTasks.Add(newTbTask);                                            //add to user tasks

                int result = db.SaveChanges();                      //save changes in db
                newTask.TaskId = newTbTask.TaskId;
            }

            displayPageState();
            mdlMsgSuccess.Text = "task created successfully";       //set massage to success
            ScriptManager.RegisterStartupScript(this, this.GetType(), "msgShow", " $('#msgModal').modal({ show: true });", true);   //show massage modal window

            if (ViewState["tab"].ToString() == "ToDo")               //don't add to session data if page on different tab (added task is "ToDo")
            {
                FillGrid(1, userID);

            }
            if (newTask.ToDate >= DateTime.Today && newTask.ToDate < DateTime.Today.AddDays(7))     //if task is in summery time range
            {
                List<tbTasks> summeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList();
                summeryList.Add(newTask);       //add to summery session data
                Session["summery"] = summeryList.AsEnumerable();
            }
            repeaterSummeryBind();
            BindDataToGridView();
        }

        //edit task, set task details in modal
        protected void BtnEdit_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idRecord = Convert.ToInt32(btn.CommandArgument);    //get task id
            tbTasks editTask = ((IEnumerable<tbTasks>)Session["data"]).ToList().Find(t => t.TaskId == idRecord);        //get Task data

            btnCreate.CssClass = "d-none";                          //hide create button on modal
            btnSave.CssClass = "btn btn-primary";                   //show save button on modal
            mdlTitle.Text = editTask.Title;                         //set Task details in modal window
            mdlDueDate.Text = editTask.ToDate.ToString("yyyy-MM-dd");
            mdlDetails.Text = editTask.Details;
            mdlID.Value = editTask.TaskId.ToString();
            mdlPriority.SelectedIndex = editTask.Priority-1;
            mdlMsg.Text = "";

            displayPageState();
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Pop", " $('#editModal').modal({ show: true });", true);  //show modal window
        }

        //save edit of task
        protected void btnSave_Click(object sender, EventArgs e)
        {
            //find task to update in session data
            tbTasks updateTask = ((IEnumerable<tbTasks>)Session["data"]).ToList().Find(t => t.TaskId == int.Parse(mdlID.Value));

            updateTask.Title = mdlTitle.Text;           //set updated data from modal window to task in session
            updateTask.Details = mdlDetails.Text;
            updateTask.ToDate = DateTime.Parse(mdlDueDate.Text);
            updateTask.Priority = short.Parse(mdlPriority.SelectedValue);

            using (var db = new sw_labEntities())
            {
                tbUsers userLogged = (tbUsers)Session["user"];                //logged user data in session
                tbUsers user = db.tbUsers.Where(u => u.Email == userLogged.Email).FirstOrDefault();                 //get logged user data from db
                tbTasks upTask = user.tbTasks.Where(t => t.TaskId == int.Parse(mdlID.Value)).FirstOrDefault();      //find task to update from user tasks

                upTask.Title = updateTask.Title;    //set task data in user tasks to updated data
                upTask.Priority = short.Parse(updateTask.Priority.ToString());
                upTask.Status = short.Parse(updateTask.Status.ToString());
                upTask.Details = updateTask.Details;
                upTask.ToDate = updateTask.ToDate;

                int result = db.SaveChanges();      //save changes in db
            }

            displayPageState();

            mdlMsgSuccess.Text = "saved updated task info";      //set message text
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", " $('#msgModal').modal({ show: true });", true);   //show message modal window

            if (updateTask.ToDate >= DateTime.Today && updateTask.ToDate < DateTime.Today.AddDays(7))     //if task in summery : status = Todo & in time range
            {
                List<tbTasks> summeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList();
                tbTasks updateTaskSummey = (summeryList.Find(t => t.TaskId == updateTask.TaskId));
                updateTaskSummey.Title = updateTask.Title;
            }

            BindDataToGridView();
            repeaterSummeryBind();
        }

        //mark task as done
        protected void BtnDone_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idRecord = Convert.ToInt32(btn.CommandArgument);

            tbTasks removeTask = ((IEnumerable<tbTasks>)Session["data"]).ToList().Find(t => t.TaskId == idRecord);  //find task in session data

            using (var db = new sw_labEntities())
            {
                tbUsers user = (tbUsers)Session["user"];                                //logged user data in session
                user = db.tbUsers.Where(u => u.Email == user.Email).FirstOrDefault();   //get logged user data from db
                tbTasks upTask = user.tbTasks.Where(t => t.TaskId == idRecord).FirstOrDefault();      //find task to update from user tasks

                upTask.Status++;       //change status from 1(todo) to 2(done)

                int result = db.SaveChanges();      //save changes in db
            }

            List<tbTasks> taskList = ((IEnumerable<tbTasks>)Session["data"]).ToList();
            taskList.Remove(removeTask);
            Session["data"] = taskList.AsEnumerable();          //remove from session data (same status for all task in session)
            List<tbTasks> summeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList();
            summeryList.Remove(summeryList.Find(t => t.TaskId == idRecord));
            Session["summery"] = summeryList.AsEnumerable();    //remove from summery session data

            displayPageState();
            repeaterSummeryBind();
            BindDataToGridView();
        }
        //mark task as archive
        protected void BtnArchive_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idRecord = Convert.ToInt32(btn.CommandArgument);

            tbTasks removeTask = ((IEnumerable<tbTasks>)Session["data"]).ToList().Find(t => t.TaskId == idRecord);  //find task in session data

            using (var db = new sw_labEntities())
            {
                tbUsers user = (tbUsers)Session["user"];                                //logged user data in session
                user = db.tbUsers.Where(u => u.Email == user.Email).FirstOrDefault();   //get logged user data from db
                tbTasks upTask = user.tbTasks.Where(t => t.TaskId == idRecord).FirstOrDefault();      //find task to update from user tasks

                upTask.Status = 3;       //change status to 3(archive)

                int result = db.SaveChanges();      //save changes in db
            }

            List<tbTasks> taskList = ((IEnumerable<tbTasks>)Session["data"]).ToList();
            taskList.Remove(removeTask);
            Session["data"] = taskList.AsEnumerable();          //remove from session data (same status for all task in session)
            if (removeTask.Status == 1 && removeTask.ToDate >= DateTime.Today && removeTask.ToDate < DateTime.Today.AddDays(7))     //if task in summery : status = Todo & in time range
                {
                List<tbTasks> summeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList();
                summeryList.Remove(summeryList.Find(t => t.TaskId == idRecord));
                Session["summery"] = summeryList.AsEnumerable();    //remove from summery session data
            }

            BindDataToGridView();
            repeaterSummeryBind();
            displayPageState();
        }

        protected void BtnRestore_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idRecord = Convert.ToInt32(btn.CommandArgument);

            tbTasks restoreTask = ((IEnumerable<tbTasks>)Session["data"]).ToList().Find(t => t.TaskId == idRecord);

            using (var db = new sw_labEntities())
            {
                tbUsers user = (tbUsers)Session["user"];                                //logged user data in session
                user = db.tbUsers.Where(u => u.Email == user.Email).FirstOrDefault();   //get logged user data from db
                tbTasks upTask = user.tbTasks.Where(t => t.TaskId == idRecord).FirstOrDefault();      //find task to restore from user tasks

                upTask.Status = 1;    //change status to 1(todo)

                int result = db.SaveChanges();      //save changes in db
            }

            List<tbTasks> taskList = ((IEnumerable<tbTasks>)Session["data"]).ToList();
            taskList.Remove(restoreTask);
            Session["data"] = taskList.AsEnumerable();  //remove from session data (same status for all task in session)

            if (restoreTask.ToDate >= DateTime.Today && restoreTask.ToDate < DateTime.Today.AddDays(7))     //if task is in summery time range
            {
                List<tbTasks> summeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList();
                summeryList.Add(restoreTask);       //add to summery session data
                Session["summery"] = summeryList.AsEnumerable();
            }

            displayPageState();
            repeaterSummeryBind();
            BindDataToGridView();
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idRecord = Convert.ToInt32(btn.CommandArgument);

            tbTasks removeTask = ((IEnumerable<tbTasks>)Session["data"]).ToList().Find(t => t.TaskId == idRecord);  //find task in session data

            using (var db = new sw_labEntities())
            {
                tbUsers user = (tbUsers)Session["user"];                                //logged user data in session
                user = db.tbUsers.Where(u => u.Email == user.Email).FirstOrDefault();   //get logged user data from db
                tbTasks delTask = user.tbTasks.Where(t => t.TaskId == idRecord).FirstOrDefault();      //find task to delete from user tasks

                user.tbTasks.Remove(delTask);       //delete task in db

                int result = db.SaveChanges();      //save changes in db
            }

            List<tbTasks> taskList = ((IEnumerable<tbTasks>)Session["data"]).ToList();
            taskList.Remove(removeTask);
            Session["data"] = taskList.AsEnumerable();  //remove from session data
            if (removeTask.Status == 1 && removeTask.ToDate >= DateTime.Today && removeTask.ToDate < DateTime.Today.AddDays(7))     //if task in summery : status = Todo & in time range
            {
                List<tbTasks> summeryList = ((IEnumerable<tbTasks>)Session["summery"]).ToList();
                summeryList.Remove(summeryList.Find(t => t.TaskId == idRecord));
                Session["summery"] = summeryList.AsEnumerable();    //remove from summery session data
            }

            BindDataToGridView();
            repeaterSummeryBind();
            displayPageState();
        }

    }
}