import MainButton from "../components/buttons/MainButton"
import Data from "../components/typography/Data"
import Label from "../components/typography/Label"
import { AreaControlProps } from "./AreaControl"

const OngoingGameInfo: React.FC<AreaControlProps> = ({ data }: AreaControlProps): JSX.Element => {
  const istakenByUserTeam: boolean = data.userTeam === data.taker

  function takeOver() {
    // do something here
    console.log('take over')
  }

  return (
    <>
      <div className='border-[1px] border-dusty-orange mb-6 bg-[#010001]'>
        <Label>Running Time</Label>
        <Data>01:00</Data>
        
        <div className='flex flex-row justify-between'>
          <div className='w-1/2 border-r border-dusty-orange'>
            <Label muted={data.userTeam !== "A"}>Team A</Label>
            <Data muted={data.userTeam !== "A"}>00:43</Data>
          </div>
          <div className='w-1/2 border-l border-dusty-orange'>
            <Label muted={data.userTeam !== "B"}>Team B</Label>
            <Data muted={data.userTeam !== "B"}>00:28</Data>
          </div>
        </div>
      </div>

      <div className="flex justify-center flex-col items-center">
        <h2 className='text-rust font-normal text-xl leading-7 text-center'>Point A Controlled by</h2>
        <div className="border-cedar border bg-night px-4 py-2 text- mb-6 text-center w-full max-w-[354px]">
          <span className='text-dusty-orange font-bold text-2xl leading-8'>
            TEAM A
          </span>
        </div>
      </div>

      <div className="absolute bottom-20 w-[calc(100%-80px)]">
        <p className='font-normal text-lg leading-[26px] text-center'>
          {data.taken && !istakenByUserTeam && !data.haveToken && `Deposit 1 xxx to take over`}
          {data.taken && !istakenByUserTeam && data.haveToken && `You have deposited 1 xxx`}
          {data.taken && istakenByUserTeam && `Defend your area until the timer ends`}
        </p>
        <MainButton
          onClick={data.taken && !istakenByUserTeam && data.haveToken ? takeOver : undefined}
          disabled={
            (data.taken && istakenByUserTeam) ||
            (data.taken && !istakenByUserTeam && !data.haveToken)
        }>
          {data.taken && !istakenByUserTeam && `TAKE OVER CONTROL`}
          {data.taken && istakenByUserTeam && `AREA CONTROLLED`}
        </MainButton>
      </div>
    </>
  )
}

export default OngoingGameInfo