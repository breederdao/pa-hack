import MainButton from "../components/buttons/MainButton"
import { IAreaControlData } from "./AreaControl"

const PickTeamButton = ({data, maxPlayers}: {data: IAreaControlData, maxPlayers: number}) => {
  // Player selected a Team
  function handleTeams(team: 'A' | 'B') {
    console.log('team selected:', team)
  }

  return (
    <>
      <div className="font-normal text-sm leading-[22px] text-center">Deposit 1 frontier chip to enter</div>
      <div className="flex flex-row justify-between">
        <div className="w-[calc(50%-1px)]">
          <MainButton onClick={()=>{handleTeams('A')}} disabled={data.teamACount === maxPlayers}>Team A</MainButton>
        </div>
        <div className="w-[calc(50%-1px)]">
          <MainButton onClick={()=>{handleTeams('B')}} disabled={data.teamBCount === maxPlayers}>Team B</MainButton>
        </div>
      </div>
    </>
  )
}

export default PickTeamButton