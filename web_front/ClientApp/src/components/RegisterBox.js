import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'

export class RegisterBox extends Component {

    constructor(props) {
      super(props);
      this.state = {
        username: "",
        password: ""
      };
      this.handleUsernameChange = this.handleUsernameChange.bind(this);
      this.handlePasswordChange = this.handlePasswordChange.bind(this);
    }
  
    submitRegister(e) {


    }

    handleUsernameChange = (e) => {
      this.setState({
        username: e.target.value
      })
      console.log(this.username)
    }

    handlePasswordChange = (e) => {
      this.setState({
        password: e.target.value
      })
      console.log(this.password)
    }
  
    render() {
      return (
        <div className="inner-container">
          <div className="header">
            Register
          </div>
          <div style={styling.outerDiv}>
              <Form style={styling.formDiv}>
                <FormGroup>
                  <FormLabel>Username</FormLabel>
                  <FormControl type="username" placeholder="username" value={this.state.username} onChange={this.handleUsernameChange}/>
                </FormGroup>

                <FormGroup controlId="formBasicPassword">
                  <FormLabel>Password</FormLabel>
                  <Form.Control type="password" placeholder="password" value={this.state.password} onChange={this.handlePasswordChange}/>
                </FormGroup>
                <div>
                  {/* {this.renderRedirect()} */}
                  <Button variant="link" onClick={this.onSubmit} >
                    {/* <img src={submitbutton} width = "200"/> */}
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