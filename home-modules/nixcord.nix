{ config, inputs, ...}:
{

 
programs = {
  nixcord = {
    enable = true;
    discord.equibop.enable = true;
    
   config.plugins = {
    alwaysTrust.enable = true;
    betterActivities.enable = true;
    betterCommands.enable = true;
    betterFolders.enable = true;
    betterForwards.enable = true;
    betterInvites.enable = true;
    betterRoleContext.enable = true;
    betterRoleDot.enable = true;
    betterSettings.enable = true;
    betterUploadButton.enable = true;
    biggerStreamPreview.enable = true;
    bypassStatus.enable = true;
    callTimer.enable = true;
    channelTabs.enable = true;
    characterCounter.enable = true;
    cleanChannelName.enable = true;
    clearUrls.enable = true;
    clipUpload.enable = true;
    copyFileContents.enable = true;
    crashHandler.enable = true;
    declutter = {
      enable = true;
      removeAvatarDecoration = true;
    };
    disableDeepLinks.enable = true;
    dontRoundMyTimestamps.enable = true;
    downloadAllAttachments.enable = true;
    dragify.enable = true;
    equibopStreamFixes.enable = true;
    equicordHelper.enable = true;
    equicordToolbox.enable = true;
    fixFileExtensions.enable = true;
    gitHubRepos.enable = true;
    globalBadges.enable = true;
    homeTyping.enable = true;
    husk = {
      emojiId = "1026532993923293184";
    };
    imageFilename.enable = true;
    instantScreenshare.enable = true;
    keyboardNavigation.enable = true;
    limitlessScreenshare.enable = true;
    loginWithQr.enable = true;
    markdownTables = {
      enable = true;
      hideToggle = false;
    };
    memberCount.enable = true;
    mentionAvatars.enable = true;
    messageLogger.enable = true;
    messageLoggerEnhanced.enable = true;
    newPluginsManager.enable = true;
    noNitroUpsell.enable = true;
    noOnboardingDelay.enable = true;
    openInApp.enable = true;
    pinIcon.enable = true;
    quickReply.enable = true;
    remixRevived.enable = true;
    replyTimestamp.enable = true;
    reviewDb.enable = true;
    serverInfo.enable = true;
    typingIndicator.enable = true;
    typingTweaks.enable = true;
    urlHighlighter.enable = true;
    validReply.enable = true;
    validUser.enable = true;
    vcPanelSettings.enable = true;
    voiceMessageTranscriber.enable = true;
    voiceStats.enable = true;
    webContextMenus.enable = true;
    webKeybinds.enable = true;
    webScreenShareFixes.enable = true;
    whoReacted.enable = true;
    whosWatching.enable = true;
  };
}
  };
};
  
}
