/// How the application responds to a provider whose build failed.
///
/// Riverpod retries failed providers automatically with exponential backoff by
/// default. That is the wrong behaviour here: it leaves a failed screen sitting
/// in a loading state for seconds while it retries in the background, so the
/// user sees an indefinite spinner instead of "You are offline" and a button.
///
/// Recovery in this application is explicit and user-driven — every
/// asynchronous surface renders through `AsyncValueView`, which shows the
/// failure and offers retry. Automatic retry is therefore disabled so that a
/// failure becomes visible on the first attempt.
Duration? noAutomaticRetry(int retryCount, Object error) => null;
