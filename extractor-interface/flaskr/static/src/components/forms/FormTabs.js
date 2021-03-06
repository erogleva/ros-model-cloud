import { h, Component } from 'preact';
import { Tabs, Tab } from "react-materialize";
import FormsWrapper from "./FormsWrapper";

export default class FormTabs extends Component {

    commonFormFields = [
        {name: 'repository', label: 'Git repository'},
        {name: 'package', label: 'Package name'}
    ];
    
    nodeFormFields = [
        ...this.commonFormFields,
        {name: 'node', label: 'Node name'}
    ];
    
    launchFormFields = [
        ...this.commonFormFields,
        {name: 'launch', label: 'Launch file name'}
    ];

    render() {
        return <Tabs>
            <Tab title="Node analysis">
                <FormsWrapper fields={this.nodeFormFields}/>
            </Tab>
            <Tab title="Launch analysis">
                <FormsWrapper fields={this.launchFormFields}/>
            </Tab>
        </Tabs>
    }
}