global class SandboxPostRefreshClass implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {

        System.debug( 'Organization ID: ' + context.organizationId() );
        System.debug( 'Sandbox ID: ' + context.sandboxId() );
        System.debug( 'Sandbox Name: ' + context.sandboxName() );

        PostRefreshBatchable newBatch = new PostRefreshBatchable();
        Database.executeBatch(newBatch);

    }
}