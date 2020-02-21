import React, { Component } from 'react';
import { Container } from 'reactstrap';
import { NavMenu } from './NavMenu';

export class Layout extends Component {
  static displayName = Layout.name;
  constructor(props) {
    super(props)
    this.state = {
      loggedin: this.props.loggedin
    }
    
  }

  render () {
    return (
      <div>
        <NavMenu
          loggedin={this.state.loggedin}
        />
        <Container>
          {this.props.children}
        </Container>
      </div>
    );
  }
}
