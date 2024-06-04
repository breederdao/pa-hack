import { useEffect, useState } from "react"
import StartGameButton from "./StartGameButton"
import { IAreaControlData } from "./AreaControl"
import PickTeamButton from "./PickTeamButton"

interface ISetup {
  data: IAreaControlData;
  hasStarted: boolean;
  setHasStarted: (value: boolean) => void;
}

const Setup: React.FC<ISetup> = ({ data, hasStarted, setHasStarted }: ISetup): JSX.Element => {
  const [playersComplete, setPlayersComplete] = useState<boolean>(false)
  const maxPlayers = 2

  useEffect(() => {
    if (data.teamACount === maxPlayers && data.teamBCount === maxPlayers && !playersComplete) {
      setPlayersComplete(true);
    }
  }, [data, playersComplete]);

  return (
    <>
      <div className="mb-8">
        <div className="bg-[#010001] border border-dusty-orange mb-6">
          <h3 className="text-walnut font-normal text-base leading-6 text-center">Prize pool</h3>
          <h2 className="text-dusty-orange font-normal text-3xl leading-[38px] text-center">5 frontier chip/s</h2>
        </div>

        <h4 className="font-bold text-base leading-6 mb-[10px]">Rules</h4>
        <p className="font-normal text-sm leading-[22px] mb-4">
          Two teams compete to control three specific zones, defined by Smart Deployables. The objective is to maintain control over these area for as long as possible.
        </p>
        <p className="font-normal text-sm leading-[22px] mb-4">
          Duration - xx:xx<br/>
          Two players per team (get final copy from Marco)
        </p>

        <p className="font-normal text-sm leading-[22px] mb-4">
          SSU 1 - Item 1<br/>
          SSU 2 - Item 2
        </p>
      </div>

      { playersComplete && !hasStarted && <StartGameButton setHasStarted={setHasStarted} /> }
      { !playersComplete && <PickTeamButton data={data} maxPlayers={maxPlayers} /> }
    </>
  )
}

export default Setup