import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'

export class LoginBox extends Component {

  constructor(props) {
    super(props);
    this.state = {
      username: "",
      password: ""
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
    console.log(this.state.username)
  }

  submitLogin(e) {
    // redirect to logged in dashboard
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
              {/* {this.renderRedirect()} */}
              <Button variant="link" onClick={(e) => this.onSubmit()} >
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