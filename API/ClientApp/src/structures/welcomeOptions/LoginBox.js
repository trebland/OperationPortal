import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class LoginBox extends Component {

  constructor(props) {
    super(props);
    this.state = {
      username: "",
      password: "",
      result: "",
      redirect: false,
      jwt: "",
      loggedin: false,
      redirectDash: false
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
    console.log(this.state.username)
  }

  handlePasswordChange = (e) => {
    this.setState ({
      password: e.target.value
    })
    console.log(this.state.password)
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

    // https://www.operation-portal.com/api/auth/token
    // http://localhost:5000/api/auth/token

    try{
        fetch('https://www.operation-portal.com/api/auth/token' , {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formBody
        })
        .then((res) => {
            console.log(res.status)
            if((res.status === 200 || res.status === 201) && this.mounted === true){
                console.log("Login successful")
                return res.text()
            }
            else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                console.log("Failed to login")
                this.setState({
                  redirect: false
                })
                return <Redirect to={{
                  pathname: '/login'
                }}/>
            }
        })
        .then((data) => {
          console.log("reached this statement")
          let res = JSON.parse(data)
          res = res.access_token
          if(this.mounted == true) {
            this.setState({
              jwt: res
            })
          }
          console.log(this.state.jwt)
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
    if (this.state.redirect && this.state.username === "staff@occ.com") {
      return <Redirect to={{
        pathname: '/admin-dashboard',
        state: { 
          jwt: this.state.jwt,
          loggedin: true
        }
      }}/>
    }
    else if(this.state.redirect) {
      return (
        <Redirect to={{
          pathname: '/dashboard',
          state: {
            jwt: this.state.jwt,
            loggedin: true
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

  // Sets variable to false when ready to leave page
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
                  <p>{this.state.result}</p>
                  <div>
                      <center>
                          {this.renderRedirect()}
                          <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{justifyContent: 'center'}}>
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