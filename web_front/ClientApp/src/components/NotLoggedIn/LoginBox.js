import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect, Router } from 'react-router-dom'

export class LoginBox extends Component {

  constructor(props) {
    super(props);
    this.state = {
      username: "",
      password: "",
      result: "",
      redirect: false,
      jwt: "",
      loggedin: false
    };
    this.handleUserNameChange = this.handleUserNameChange.bind(this)
    this.handlePasswordChange = this.handlePasswordChange.bind(this)
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

  // postAndFetchData = (path) => {
  //   fetch('http://operation-portal.com' + path , {
  //     method: "POST",
  //     headers: {
  //       'Content-type': 'application/json'
  //     },
  //     body: JSON.stringify(this.state)
  //     })
  //     .then((response) => {
  //       console.log(response.status)
  //       if(response.status === 200 || response.status === 201) {
  //         return response.text()
  //       } else if (response.status === 401 || response.status === 400 || response.status === 500 && this.mounted === true) {
  //         this.setState({
  //           redirect: false,
  //           result: 'Username or password incorrect.'
  //         })
  //         return
  //       }
  //     })
  //     .then((data) => {
  //       let res = JSON.parse(data)
  //       res = res.token
  //       if(this.mounted == true) {
  //         this.setState({
  //           jwt: res
  //         })
  //       }
  //       console.log(this.state.jwt)
  //     })
  //     .then(() => {this.setRedirect()})
  //     .catch(() => {
  //       console.log('didnt post')
  //     })
  // }

  // onSubmit = (e) => {
  //   this.postAndFetchData('api/auth/token')
  // }

  setRedirect = () => {
    this.setState({
      redirect: true,
      loggedin: true
    })
  }

  renderRedirect = () => {
    if (this.state.redirect) {
      return <Redirect to={{
        pathname: '/user',
        state: { 
          username: this.state.username,
          loggedin: true
        }
      }}/>
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
      <div className="inner-container">
        <div className="header">
          Login
        </div>
        <div className="box" style={styling.outerDiv}>
          <Form style={styling.formDiv}>
            <FormGroup>
              <FormLabel>Username</FormLabel>
              <FormControl type="username" placeholder="username" value={this.state.username} onChange={this.handleUserNameChange} />
            </FormGroup>

            <FormGroup controlId="formBasicPassword">
              <FormLabel>Password</FormLabel>
              <Form.Control type="password" placeholder="password"  value={this.state.password} onChange={this.handlePasswordChange}/>
            </FormGroup>
            <p>{this.state.result}</p>
            <div>
              {this.renderRedirect()}
              <Button type="submit" size="lg" onClick={this.setRedirect} >
                Submit
              </Button>
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
  }
}