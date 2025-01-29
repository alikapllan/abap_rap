@EndUserText.label: 'Event data to save in DB'
define abstract entity zahk_s_block_eventdata
{
  salesDocNo        : abap.char(10);
  createdBy         : abap.char(12);
  blockedStatus     : abap.char(2);
  blockedStatusText : abap.char(10);
  blockedOn         : timestampl;
}
