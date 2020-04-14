import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect, Link } from 'react-router-dom'

export class LoginBox extends Component {
  constructor(props) {
    super(props);
    this.state = {
      username: "",
      password: "",
      result: "",
      loginSuccess: false,
      redirect: false,
      jwt: "",
      loggedin: false,
      redirectDash: false,
      profile: {},
      role: ''
    };
    this.handleUserNameChange = this.handleUserNameChange.bind(this)
    this.handlePasswordChange = this.handlePasswordChange.bind(this)
  }

  componentDidMount() {
    this.mounted = true
  }

  handleUserNameChange = (e) => {
    this.setState ({
      username: e.target.value
    })
  }

  handlePasswordChange = (e) => {
    this.setState ({
      password: e.target.value
    })
  }

  onSubmit = (e) => {

    let submitState = {
      grant_type: "password",
      username: this.state.username,
      password: this.state.password
    }

    let formBody = []
    for(let property in submitState) {
      let encodedKey = encodeURIComponent(property);
      let encodedValue = encodeURIComponent(submitState[property]);
      formBody.push(encodedKey + "=" + encodedValue);
    }
    formBody = formBody.join("&");

    try{
        fetch('/api/auth/token' , {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formBody
        })
        .then((res) => {
            console.log(res.status)
            if((res.status === 200 || res.status === 201) && this.mounted === true){
                this.setState({
                    loginSuccess: true
                })
                return res.text()
            }
            else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                this.setState({
                    redirect: false,
                    loginSuccess: false
                })
                return res.text()
            }
        })
        .then((data) => {
            if (!this.state.loginSuccess) {
                this.setState({
                    result: 'Incorrect username or password'
                })
            }
            else {
                let res = JSON.parse(data)
                res = res.access_token
                if (this.mounted == true) {
                    this.setState({
                        jwt: res
                    })
                }
                console.log(this.state.jwt)
            }
        })
        .then(() => {
            if (this.state.loginSuccess) {
                this.getRole()
            }
        })
        // set redirect after getting token so that the page doesnt change
        .then(() => {
          this.setState({
            redirect: true
          })
        })
    }
    catch(e) {
      console.log("didnt post")
    }
  }

  getRole = () => {
    try {
      fetch('/api/auth/user' , {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.state.jwt}`
        },
      })
      .then((res) => {
        console.log(res.status)
        if((res.status === 200 || res.status === 201) && this.mounted === true){
            console.log("retrieval successful")
            return res.text()
        }
        else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
            console.log("Failed to retrieve")
            this.setState({
              redirect: false
            })
            return
        }
      })
      .then((data) => {
        console.log("reached this statement in getrole")
        let res = JSON.parse(data)
        res = res.profile.role
        if(this.mounted == true) {
          this.setState({
            role: res
          })
        }
        console.log(this.state.role)
      })
    }
    catch(e) {
      console.log("didnt post")
    }
  }


  setRedirect = () => {
    this.setState({
      redirect: true,
      loggedin: true
    })
  }

  setRedirectDash = () => {
    this.setState({
      redirectDash: true,
    })
  }

  renderRedirect = () => {
    if (this.state.redirect && this.state.role === "Staff") {
      return <Redirect to={{
        pathname: '/admin-dashboard',
        state: { 
          jwt: this.state.jwt,
          loggedin: true
        }
      }}/>
    }
    else if(this.state.redirect && ((this.state.role === "Volunteer") || (this.state.role === "BusDriver"))) {
      return (
        <Redirect to={{
          pathname: '/dashboard',
          state: {
            jwt: this.state.jwt,
            loggedin: true,
            role: this.state.role
          }
        }}/>
      )
    }
    else if(this.state.redirectDash) {
      return (
        <Redirect to={{
          pathname: '/',
        }}/>
      )
    }
  }

  componentWillUnmount() {
    this.mounted = false
  }


  render() {
    return (
        <div>
          <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectDash}>
            Back to Dashboard
          </Button>
          <div style={styling.header}>
            <h1>Login</h1>
          </div>
          <div className="box" style={styling.outerDiv}>
              <Form style={styling.formDiv}>
                  <FormGroup>
                      <FormLabel>Email</FormLabel>
                      <FormControl type="username" placeholder="email" value={this.state.username} onChange={this.handleUserNameChange} />
                  </FormGroup>

                  <FormGroup controlId="formBasicPassword">
                      <FormLabel>Password</FormLabel>
                      <Form.Control type="password" placeholder="password"  value={this.state.password} onChange={this.handlePasswordChange}/>
                  </FormGroup>
                    <p style={this.state.loginSuccess ? { color: 'green' } : { color: 'red' }}>{this.state.result}</p>
                  <div>
                      <center>
                          {this.renderRedirect()}
                          <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{justifyContent: 'center'}}>
                              Submit
                          </Button>
                          <br/>
                          <Link to={'/password-reset-request'} style={{color: '#333'}}>Forgot Password</Link>
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
      margin: '8%'
  },
  header: {
      textAlign: 'center',
      justifyContent: 'center',
      marginTop: '40px'
  },
  butt: {
    marginTop: '15px',
    marginLeft: '15px'
  }
}