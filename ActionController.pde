class ActionController implements ActionModelClient, ActionViewClient {
    ActionBaseModel actionModel;
    ActionView actionView;


    ActionController(ViewBase parentView, ActionBaseModel actionModel) {
        this.actionModel = actionModel;
        this.actionView = new ActionView(parentView, actionModel);

        this.actionModel.registerClient(this);
        this.actionView.registerClient(this);
    }
}
