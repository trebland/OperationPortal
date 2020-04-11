import React, { Component } from 'react'
import { Button } from 'react-bootstrap/'

export class EditButton extends Component {
    handleClick = () => {
        this.props.onButtonClick(this.props.value);
    }

    render() {
        return (
            <Button variant="primary" onClick={this.handleClick}>
                Edit
            </Button>  
        );
    }
}