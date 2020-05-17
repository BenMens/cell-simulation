class CellController implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;

    ArrayList<ActionController> actionControllers = new ArrayList<ActionController>();


    CellController(CellModel cellModel) {
        this.cellModel = cellModel;
        this.cellView = viewFactory.createView(cellModel);

        this.cellView.position = cellModel.position.copy().mult(100).add(10, 10);

        this.cellModel.registerClient(this);
        this.cellView.registerClient(this);
    }


    void destroy() {
        cellView.setParentView(null);
        cellView.unregisterClient(this);
        cellModel.unregisterClient(this);
    }


    void onAddAction(ActionBaseModel actionModel) {
        ActionController newActionController = new ActionController(actionModel);
        cellView.addChildView(newActionController.actionView);

        actionControllers.add(newActionController);
    }
}
