import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class RegisterBox extends Component {

    constructor(props) {
      super(props);
      this.state = {
        firstname: "",
        lastname: "",
        email: "",
        password: "",
        redirect: false,
        result: ""
      };
      this.handleFirstnameChange = this.handleFirstnameChange.bind(this);
      this.handleLastnameChange = this.handleLastnameChange.bind(this);
      this.handlePasswordChange = this.handlePasswordChange.bind(this);
    }

    componentDidMount() {
      this.mounted = true
    }

    componentWillUnmount() {
      this.mounted = false
    }

    onSubmit = (e) => {
      try{
        fetch('http://operation-portal.com' + '/api/auth/register' , {
        method: "POST",
        headers: {
          'Content-type': 'application/json',
        },
        body: JSON.stringify(this.state)
        })
        .then((response) => {
          console.log(response.status)
          if((response.status === 200 || response.status === 201) && this.mounted === true) {
            this.setState({redirect: true})
            return response.text()
          } else if ((response.status === 401 || response.status === 400 || response.status === 500 ) && this.mounted === true) {
            console.log('hit else if')
            return this.setState({
              redirect: false,
              result: 'Username already exists.'
            })
          }
        })
      }catch(e) {
        console.log("Did not connect")
      }
    }

    renderRedirect = () => {
      if (this.state.redirect) {
        return <Redirect to='/login' />
      }
    }

    handleFirstnameChange = (e) => {
      this.setState({
        firstname: e.target.value
      })
      console.log(this.state.firstname)
    }

    handleLastnameChange = (e) => {
      this.setState({
        lastname: e.target.value
      })
      console.log(this.state.lastname)
    }

    handleEmailChange = (e) => {
      this.setState({
        email: e.target.value
      })
      console.log(this.state.email)
    }

    handlePasswordChange = (e) => {
      this.setState({
        password: e.target.value
      })
      console.log(this.state.password)
    }
  
    render() {
      return (
        <div className="inner-container">
          <div className="header">
            <h1>Register</h1>
          </div>
          <div style={styling.outerDiv}>

              <Form style={styling.formDiv}>
                <FormGroup>
                  <FormLabel>First Name</FormLabel>
                  <FormControl type="text" placeholder="First Name" value={this.state.firstname} onChange={this.handleFirstnameChange}/>
                </FormGroup>

                <FormGroup>
                  <FormLabel>Last Name</FormLabel>
                  <FormControl type="text" placeholder="Last Name" value={this.state.lastname} onChange={this.handleLastnameChange}/>
                </FormGroup>

                <FormGroup>
                  <FormLabel>Email</FormLabel>
                  <FormControl type="email" placeholder="Email" value={this.state.email} onChange={this.handleEmailChange}/>
                </FormGroup>

                <FormGroup controlId="formBasicPassword">
                  <FormLabel>Password</FormLabel>
                  <Form.Control type="password" placeholder="Password" value={this.state.password} onChange={this.handlePasswordChange}/>
                </FormGroup>

                <div>
                  {this.renderRedirect()}
                  <Button type="submit" size="lg" onClick={this.onSubmit} >
                    Submit
                  </Button>
                  <p>{this.state.result}</p>
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