import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class PasswordResetRequest extends Component {
    constructor(props) {
        super(props);
        this.state = {
            email: "",
            result: "",
            redirect: false,
            forward: false,
        };
        this.handleEmailChange = this.handleEmailChange.bind(this)
    }

    componentDidMount() {
        this.mounted = true
    }

    handleEmailChange = (e) => {
        this.setState({
            email: e.target.value
        })
        console.log(this.state.username)
    }

    handleFormSubmit = (e) => {
        e.preventDefault();
    }

    onSubmit = (e) => {
        e.preventDefault();

        if (!this.state.email) {
            this.setState({
                success: false,
                result: 'Must provide a valid email address'
            })
            return
        }

        try {
            fetch('/api/auth/password-reset-request', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ Email: this.state.email })
            })
            .then((res) => {
                if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                    this.setState({
                        result: 'Added the new training successfully!',
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
                    this.setState({
                        forward:true
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
            redirect: true
        })
    }

    renderRedirect = () => {
        if (this.state.redirect) {
            return (
                <Redirect to={{
                    pathname: '/login',
                }} />
            )
        }
        else if (this.state.forward) {
            return (
                <Redirect to={{
                    pathname: '/password-reset-confirm',
                    state: {
                        email: this.state.email
                    }
                }} />  
            )
        }
    }

    render() {
        return (
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Login
          </Button>
                <div style={styling.header}>
                    <h1>Forgot Password</h1>
                </div>
                <div style={styling.infoText}>
                    <p>Enter your email address and an email with instructions to reset your password will be sent to you. </p>
                </div>
                <div className="box" style={styling.outerDiv}>
                    <Form style={styling.formDiv}>
                        <FormGroup>
                            <FormLabel>Email</FormLabel>
                            <FormControl type="name" placeholder="email" value={this.state.email} onChange={this.handleEmailChange} onKeyPress={e => {
                                if (e.key === 'Enter') e.preventDefault();
                            }}/>
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