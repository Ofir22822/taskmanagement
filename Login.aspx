<%@ Page Title="Login" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site1.Master" CodeBehind="Login.aspx.cs" Inherits="TaskManagementSystem.Login" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        $(document).ready(function () {
            console.log();
            if ($("div[id*='registerMsg']").text() != "")
                $("div[id*='registerMsg']").addClass("pb-2 pt-0");
        });
    </script>

    <div class="container-fluid h-100" style="border: 0px solid black">
        <div class="row justify-content-center h-100">
            <div class="card-body w-50">
                <!--massage after user registration!-->
                <div runat="server" id="registerMsg" class="m-auto text-primary text-center h3" style="max-width: 30rem;"></div>
                <!--login details!-->
                <div class="m-auto">
                    <div class="card bg-white mb-3 m-auto w-auto" style="max-width: 30rem;">
                        <div class="card-header">Login</div>
                        <div class="card-body">
                            <!--email field!-->
                            <div class="form-group container">
                                <div class="row">
                                    <label class="col-auto pl-0">Email address</label>
                                    <asp:RequiredFieldValidator runat="server" ID="userEmailError" ControlToValidate="userEmail" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                                </div>
                                <asp:TextBox runat="server" ID="userEmail" TextMode="Email" CssClass="form-control row m-0" placeholder="Enter email"></asp:TextBox>
                            </div>
                            <!--password field!-->
                            <div class="form-group container">
                                <div class="row">
                                    <label class="col-auto pl-0">Password</label>
                                    <asp:RequiredFieldValidator runat="server" ID="userPasswordError" ControlToValidate="userPassword" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                                </div>
                                <asp:TextBox runat="server" ID="userPassword" TextMode="Password" CssClass="form-control row m-0" placeholder="Enter password"></asp:TextBox>
                            </div>
                            <!--submit button + error text!-->
                            <div class="row h-100">
                                <div class="col-auto">
                                    <asp:Button runat="server" ID="btnLogin" Text="Submit" OnClick="btnLogin_Click" CssClass="btn btn-primary" />
                                </div>
                                <div runat="server" id="loginError" class="col-auto mt-auto mb-auto text-danger"></div>
                            </div>
                        </div>
                    </div>
                    <div class="m-auto" style="max-width: 30rem;">
                        <a href="register.aspx" class="float-right">Create new user</a>
                    </div>
                </div>
            </div>
        </div>
    </div>




</asp:Content>
