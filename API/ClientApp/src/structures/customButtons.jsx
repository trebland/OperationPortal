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

export class DeleteButton extends Component {
    handleClick = () => {
        if (!window.confirm("Are you sure you want to delete this?  Deletion cannot be reversed.")) {
            return;
        }
        this.props.onButtonClick(this.props.value);
    }

    render() {
        return (
            <Button variant="danger" onClick={this.handleClick} style={{ float: 'right' }}>
                Delete
            </Button>
        );
    }
}

export class UserSelectButton extends Component {
    handleClick = () => {
        this.props.onButtonClick(this.props.value, this.props.name);
    }

    render() {
        return (
            <Button variant="primary" onClick={this.handleClick}>
                Select
            </Button>
        );
    }
}