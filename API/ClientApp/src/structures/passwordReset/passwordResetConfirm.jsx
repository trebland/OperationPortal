import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import queryString from 'query-string'

export class PasswordResetConfirm extends Component {
    constructor(props) {
        super(props);

        let params = queryString.parse(this.props.location.search)

        this.state = {
            email: params.email || (this.props.location.state ? this.props.location.state.email : "" ) || "",
            token: params.token || "",
            password: "",
            confirmPassword: "",
            result: "",
            redirectBack: false,
            redirectLogin: false
        };

        this.handleTokenChange = this.handleTokenChange.bind(this)
        this.handlePasswordChange = this.handlePasswordChange.bind(this)
        this.handleConfirmPasswordChange = this.handleConfirmPasswordChange.bind(this)

        console.log(this.state.email)
    }

    componentDidMount() {
        this.mounted = true
    }

    handleTokenChange = (e) => {
        this.setState({
            token: e.target.value
        })
        console.log(this.state.username)
    }

    handlePasswordChange = (e) => {
        this.setState({
            password: e.target.value
        })
        console.log(this.state.username)
    }

    handleConfirmPasswordChange = (e) => {
        this.setState({
            confirmPassword: e.target.value
        })
        console.log(this.state.username)
    }

    onSubmit = (e) => {
        e.preventDefault();

        if (!this.state.email) {
            this.setState({
                success: false,
                result: 'An error occurred.  Please go back to the previous page and try again.'
            })
            return
        }

        if (!this.state.token) {
            this.setState({
                success: false,
                result: 'You must provide the code emailed to you to change your password.'
            })
            return
        }

        if (this.state.password != this.state.confirmPassword) {
            this.setState({
                success: false,
                result: 'Passwords do not match.'
            })
            return
        }

        try {
            fetch('/api/auth/password-reset-confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ Email: this.state.email, Token: this.state.token, Password: this.state.password })
            })
                .then((res) => {
                    if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                        this.setState({
                            success: true,
                        })
                        return
                    }
                    else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                        this.setState({
                            success: false,
                        })
                        return res.json()
                    }
                })
                .then((data) => {
                    if (!this.state.success) {
                        this.setState({
                            result: data.error
                        })
                    }
                    else {
                        alert("Your password was changed successfully!  You will now be redirected to the login page");
                        this.setState({
                            redirectLogin: true
                        })
                    }
                })
        }
        catch (e) {
            console.log(e);
        }
    }


    setRedirect = () => {
        this.setState({
            redirectBack: true
        })
    }

    renderRedirect = () => {
        if (this.state.redirectLogin) {
            return (
                <Redirect to={{
                    pathname: '/login',
                }} />
            )
        }
        else if (this.state.redirectBack) {
            return (
                <Redirect to={{
                    pathname: '/password-reset-request',
                }} />
            )
        }
    }

    render() {
        return (
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back
                </Button>
                <div style={styling.header}>
                    <h1>Forgot Password</h1>
                </div>
                <div style={styling.infoText}>
                    <p>Please enter the code emailed to you into the box below, or follow the link that was emailed to you, then enter a new password. </p>
                    <p>If you did not receive an email, you may have entered the wrong email address for your account.  Please double check which address your account is signed up with.</p>
                    <p>Passwords must be at least 6 characters long and contain at least one number, one uppercase letter, and one non-alphanumeric symbol.</p>
                </div>
                <div className="box" style={styling.outerDiv}>
                    <Form style={styling.formDiv}>
                        <FormGroup>
                            <FormLabel>Reset Code</FormLabel>
                            <Form.Control as="textarea" placeholder="Reset Code" value={this.state.token} onChange={this.handleTokenChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Password</FormLabel>
                            <FormControl type="password" placeholder="Password" value={this.state.password} onChange={this.handlePasswordChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Confirm Password</FormLabel>
                            <FormControl type="password" placeholder="Confirm Password" value={this.state.confirmPassword} onChange={this.handleConfirmPasswordChange} />
                        </FormGroup>
                        <p style={this.state.success ? { color: 'green' } : { color: 'red' }}>{this.state.result}</p>
                        <div>
                            <center>
                                {this.renderRedirect()}
                                <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{ justifyContent: 'center' }}>
                                    Submit
                                </Button>
                            </center>
                        </div>
                    </Form>
                </div>
            </div>
        );
    }
}

const styling = {
    formDiv: {
        width: '50%',
    },
    outerDiv: {
        display: 'flex',
        justifyContent: 'center',
        margin: '8%',
        marginTop: '2%'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    },
    infoText: {
        marginTop: '20px',
        textAlign: 'center',
        justifyContent: 'center'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    }
}