class ActionController implements ActionModelClient, ActionViewClient {
    ActionBaseModel actionModel;
    ActionView actionView;


    ActionController(ActionBaseModel actionModel) {
        this.actionModel = actionModel;
        this.actionView = new ActionView(actionModel);

        this.actionModel.registerClient(this);
        this.actionView.registerClient(this);
    }
}
