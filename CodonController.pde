class CodonController implements CodonModelClient, CodonViewClient {
    CodonBaseModel codonModel;
    CodonView codonView;


    CodonController(ViewBase parentView, CodonBaseModel codonModel) {
        this.codonModel = codonModel;
        this.codonView = new CodonView(parentView, codonModel);

        this.codonModel.registerClient(this);
        this.codonView.registerClient(this);
    }


    void destroy() {
        codonView.setParentView(null);
        codonView.unregisterClient(this);
        codonModel.unregisterClient(this);
    }

    void onDestroy(CodonBaseModel codonModel) {
        this.destroy();
    }
}
